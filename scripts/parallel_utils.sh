

wait_until_jobs_below()
{
	local max_jobs=$1

	while [ $(jobs | wc -l) -ge $max_jobs ]
	do
		sleep 5
	done
}

wait_until_all_complete()
{
	local result=0
	for job_id in $*
	do
		if ! wait $job_id
		then
			result=1
		fi
	done
	return $result
}

