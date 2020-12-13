SELECT source_schema,COUNT(*),TRUNC(collect_datetime)
  FROM qp_content_admin.meta_content
 GROUP BY source_schema,TRUNC(collect_datetime)
 ORDER BY source_schema,TRUNC(collect_datetime);

SELECT source_schema,COUNT(*)
 FROM qp_content_admin.meta_content
 GROUP BY source_schema;

