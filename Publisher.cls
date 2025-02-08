public class Publisher {
    public String publisher{ get; set;}
    public List<Book> Books{ get; set;}
    
    public class Book {
        public String Author { get; set; }  
        public String Title { get; set; }  
        public Integer Edition { get; set; } 
    }

}