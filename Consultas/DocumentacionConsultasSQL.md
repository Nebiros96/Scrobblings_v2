Documentación consultas SQL para el analísis  

**Glosario**  
**Scrobblings**: Término acuñado por Lastfm, es el equivalente a una reproducción realizada en cualquier plataforma para escuchar archivos de audio  
Se tienen en cuenta las siguientes condiciones para considerar un (1) scrobbling  
- 50% del tiempo: Cuando el archivo de audio supera el 50% de la duración*  
-- Si el tiempo de reproducción es mayor o igual a 240 segundos (4 minutos) se considera Scrobbling  
- La duración del archivo de audio tiene que ser mayor a 30000 ms (30 segundos, 0 milésimas)  

- **Artist_Top1Month**: Artista más escuchado por mes y ratio con respecto al total de reproducciones  
- **AvgScrobblingsPerArtist**: Promedio de reproducciones por canción por artista  
- **DayStreakByArtist**: Cantidad de días consecutivos escuchando el artista  
- **DayStreaks**: Cantidad de días consecutgivos con al menos un (1) scrobble  
- **GapsBetweenArtist**: Mayor cantidad de tiempo (dd y YYYY) entre la última y penúltima reproducción de un artista  
- **NewArtistsByMonth**: Cantidad de artistas nuevos por mes y ratio entre el total de escuchados  
- **OneHitWonders**: Artistas con más reproducciones, pero solo una canción escuchada  
- **OngoingGapsBetweenArtists**: Artistas con la mayor diferencia de tiempo entre el último día y su última reproducción  
- **ScrobblingsByDayWeek**: Reproducciones por días de la semana  
- **ScrobblingsDayHour**: Reproducciones por día y hora  
- **StreakArtist**: Cantidad de reproducciones consecutivas de un mismo artista  
- **StreakSong**: Cantidad de reproducciones consecutivas de una misma canción  
- **VecesEnTop5**: Cantidad de veces en las que un artista ha aparecido en el top 5 de los más escuchados, agrupados mensualmente  
- **WeeksPerArtist**: Cantidad de semanas por artista  
