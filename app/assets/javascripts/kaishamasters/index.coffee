jQuery ->
  create_datatable
    table_id: '#kaishamaster'
    new_modal_id: '#kaisha-new-modal'
    edit_modal_id: '#kaisha-edit-modal'
    delete_path: '/kaishamasters/id'
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]

  $('#kaisha-new-modal').on 'show', ()->
    $(this).modal('show')
    $('#kaishamaster_会社コード').val('')
    $('#kaishamaster_会社名').val('')
    $('#kaishamaster_備考').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#kaisha-edit-modal').on 'show', (e, selected_row_data)->
    $(this).modal('show')
    $('#kaishamaster_会社コード').val(selected_row_data[0])
    $('#kaishamaster_会社名').val(selected_row_data[1])
    $('#kaishamaster_備考').val(selected_row_data[2])
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
