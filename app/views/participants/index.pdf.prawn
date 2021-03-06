# encoding: UTF-8
prawn_document( :page_size => 'A4', :page_layout => :portrait, :margin => 25) do |pdf|
  pdf.font("#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf")
  render "layouts/header", :pdf => pdf

  header_list={
    starting_no:"#",
    name:"Jméno",
    category:"Kategorie",
    team:"Jednota",
    yob:"Rok nar."
  }

  if pdf_grouping
    participant_groups=@participants.to_a.group_by(& pdf_grouping)
    case pdf_grouping
    when :category
      selection={starting_no:{width:70},name:{width:250},yob:{width:80},team:{width:130}}
    when :team
      selection={starting_no:{width:70},name:{width:250},yob:{width:80},category:{width:130}}
    end
    selection.delete(pdf_grouping)
  else
    participant_groups={all:@participants}
    selection={starting_no:{width:70},name:{width:250},category:{width:80},team:{width:130}}
  end

  participant_groups.each_pair do |key,participant_list|
    data=[]
    participant_list.each do |participant|
      data<<{
        starting_no:participant.starting_no,
        name:participant.display_name,
        category:participant.category.title,
        team:participant.team.title,
        yob:participant.person.yob
      }
    end

    pdf_table_break(pdf)
    if pdf_table_title(key)
      pdf.text(pdf_table_title(key), :size => 16)# Title
    end

    pdf.font_size(10)

    pdf.table(pdf_transform_data(header_list,data,selection), :header => true) do
      selection.values.map{ |x| x[:width] }.each_with_index do |val,index|
        column(index).width = val
      end
    end
  end
end
