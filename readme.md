## log2es
Load arbritrary plain-text logs into ElasticSearch

## Installation

1. Get ElasticSearch server ready

2. Setup Perl Environment

```
cpan LWP::UserAgent JSON::XS
```

## Example usage

Load the first two fields from /etc/passwd:

<pre>
./logparser-es.pl \
        --regex '^(?&lt;name>[^:]+):(?&lt;password>[^:]+)' \
        --es 'http://127.0.0.1:9200/aaaforensics/logs/' \
        /etc/passwd
</pre>

## Perform database query

Lookup data,

```
curl 127.0.0.1:9200/aaaforensics/_search | json_pp

{
   "hits" : {
      "total" : 810,
      "max_score" : 1,
      "hits" : [
         {
            "_type" : "logs",
            "_source" : {
               "name" : "root",
               "password" : "*"
            },
            "_id" : "AU9iWvvtIcpmawnfW30f",
            "_index" : "aaaforensics",
            "_score" : 1
         },
         {
            "_index" : "aaaforensics",
            "_score" : 1,
            "_type" : "logs",
            "_id" : "AU9iWvv2IcpmawnfW30h",
            "_source" : {
               "password" : "*",
               "name" : "_uucp"
            }
         },
         {
            "_id" : "AU9iWvv7IcpmawnfW30i",
            "_source" : {
               "password" : "*",
               "name" : "_taskgated"
            },
            "_type" : "logs",
            "_score" : 1,
            "_index" : "aaaforensics"
         },
         {
            "_source" : {
               "name" : "_lp",
               "password" : "*"
            },
            "_id" : "AU9iWvwGIcpmawnfW30l",
            "_type" : "logs",
            "_score" : 1,
            "_index" : "aaaforensics"
         },
         {
            "_index" : "aaaforensics",
            "_score" : 1,
            "_type" : "logs",
            "_id" : "AU9iWvwIIcpmawnfW30m",
            "_source" : {
               "password" : "*",
               "name" : "_postfix"
            }
         }
      ]
   },
   "took" : 2,
   "timed_out" : false,
   "_shards" : {
      "failed" : 0,
      "total" : 5,
      "successful" : 5
   }
}
```
