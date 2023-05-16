start_time=$(date +%s) 

# Run your command here

end_time=$(date +%s)  
time_elapsed=$((end_time - start_time))
echo "Time elapsed: $((time_elapsed*1000)) ms"
