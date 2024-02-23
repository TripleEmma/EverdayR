##### Functionals
### Advanced R 
### https://www.youtube.com/watch?v=MuOxlUN9q4E

## some key points to refresh
# map() returns a list;
# map_*() would check if the output could match the type you want it to output,
# which is a good thing! If it does coercion the output, there will be warning; 
# map_dbl, map_int, map_chr, map_lgl; they return an atomic vector of the specific type.
# map() function and its friends and variants could pass addtional argument to the function

# the following examples are from the online course and Advanced R
# go through these examples remind me what functionals are
#####

library(tidyverse)
###
characters <- list(
    harry = list(name = 'Harry Potter', gender = 'Male', pet = 'Hedwig'),
    hermione = list(name = 'Hermione Granger', gender = 'Female', pet = 'Crookshank'),
    ron = list(name = 'Ron Weasley', gender = 'Male', pet = list('Scabbers', 'Pigwidgeon'))
)
map(characters, 2) # extract by position
map(characters, 'name') # extract by name
pets <- map(characters, 'pet') # the last element is a nested list

###
map_dbl(mtcars, mean, na.rm=TRUE) # additional argument passed to the function
map_dbl(mtcars, function(x)mean(x, na.rm=TRUE)) # anonymous function, pair with 'x'
map_dbl(mtcars, ~mean(.x, na.rm=TRUE)) # using '~', pair '~' with '.x'

### 
plus <- function(x, y)x+y
x <- c(0, 0, 0, 0)
map_dbl(x, plus, runif(1)) # runif(1) ran only once
map_dbl(x, ~plus(.x, runif(1))) # runif(1) ran independently four times

###
map(1:3, runif) # run runif(1), runif(2), and runif(3)
map(1:3, ~runif(2)) # run runif(2) for three times; when using '~', usually there should be '.x'
map(1:3, runif(2)) # ?

###
# run t.test(rpois(10, 10), rpois(10, 7)) 100 times
trials <- map(1:100, ~ t.test(rpois(10, 10), rpois(10, 7))) 
df_trials <- tibble::tibble(p_value = map_dbl(trials, "p.value"))
# extract by names 'p.value'
df_trials %>%
    ggplot(aes(x = p_value, fill = p_value < 0.05)) +
    geom_dotplot(binwidth = .01) +  # geom_histogram() as alternative
    theme(
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position = "top"
    )

### modify()
df <- data.frame(x = 1:3, 
                 y = 6:4)
map(df, ~.x*2)
modify(df, ~.x*2)

### walk()
cyls <- split(mtcars, mtcars$cyl)
path <- file.path(paste0('cyl-', names(cyls), '.csv'))
walk2(cyls, path, write.csv)

### imap(x, f)
# imap(x, f) is equivalent to map2(x, names(x), f) if x has names;
# imap(x, f) is equivalent to map2(x, seq_along(x), f) if x does not have names;
cyls <- split(mtcars, mtcars$cyl)
names(cyls) <- file.path(paste0('cyl-', names(cyls), '.csv'))
imap(cyls, write.csv) # compare it with walk2(cyls, path, write.csv)

###
df <- list(sp1 = sample(1:100, 10),
           sp2 = sample(1:100, 10),
           sp3 = sample(1:100, 10))
map(df, sum)
pmap(df, sum)

### reduce
# reduce(list1, left_join)

### some(.x, .p); every(.x, .p); 
### detect(.x, .p); detect_index(.x, .p); 
### keep(.x, .p); discard(.x, .p)
df <- data.frame(
    num1 = c(0, 10, 20),
    num2 = c(5, 6, NA),
    chr1 = c('a', 'b', 'c'),
    stringsAsFactors = FALSE
)
str(map(keep(df, is.numeric), mean, na.rm = TRUE))

### 
df <- data.frame(x=1:3, y=c('a','b','c'))
map(df, mean)
apply(df, 2, mean)
