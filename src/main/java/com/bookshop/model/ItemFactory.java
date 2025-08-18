package com.bookshop.model;

public class ItemFactory {

    public static Item createItem(String title, String author, double price, int stock,
                                  String description, String category, String image, String addedBy) {
        Item item = new Item();
        item.setTitle(title);
        item.setAuthor(author);
        item.setPrice(price);
        item.setStockQuantity(stock);
        item.setDescription(description);
        item.setCategory(category);
        item.setImage(image);
        item.setAddedBy(addedBy);
        return item;
    }
    
    public static Item createItemWithId(int itemId, String title, String author, double price, int stock,
                                        String description, String category, String image) {
        Item item = new Item();
        item.setItemId(itemId);
        item.setTitle(title);
        item.setAuthor(author);
        item.setPrice(price);
        item.setStockQuantity(stock);
        item.setDescription(description);
        item.setCategory(category);
        item.setImage(image);
        return item;
    }
}
