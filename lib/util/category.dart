String getCategoryTranslation(String category) {
    switch (category) {
      case 'Human':
        return 'Orang';
      case 'Pet':
        return 'Peliharaan';
      case 'Goods':
        return 'Barang';
      default:
        return category;
    }
  }