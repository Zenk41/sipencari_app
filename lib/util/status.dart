String getStatusTranslation(String status) {
    switch (status) {
      case 'NotFound':
        return 'Dicari';
      case 'Found':
        return 'Ditemukan';
      case 'Goods':
        return 'Barang';
      default:
        return status;
    }
  }