From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Mon, 16 Jun 2014 13:20:32 -0600
Message-ID: <539F4380.5090001@hp.com>
References: <1400185026-3972-1-git-send-email-jack@suse.cz> <1400185026-3972-3-git-send-email-jack@suse.cz> <537B1353.8060704@hp.com> <20140520135723.GB15177@thunk.org> <538CB83C.9080409@hp.com> <20140603085205.GA29219@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080808040107080107050708"
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:40304 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbaFPTYS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2014 15:24:18 -0400
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id DFE331628
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2014 19:04:57 +0000 (UTC)
In-Reply-To: <20140603085205.GA29219@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080808040107080107050708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 06/03/2014 02:52 AM, Jan Kara wrote:
>   I'd interpret the data a bit differently :) With your patch the
> contention for resource - access to orphan list - is split between
> s_orphan_lock and s_orphan_op_mutex. For the smaller machine contending
> directly on s_orphan_lock is a win and we spend less time waiting in total.
> For the large machine it seems beneficial to contend on the hashed mutex
> first and only after that on global lock. Likely that reduces amount of
> cacheline bouncing, or maybe the mutex is more often acquired during the
> spinning phase which reduces the acquisition latency.
> 
>   Sure, it is attached.
> 
> 								Honza
> 

Thanks Jan for the test program.

Anyway I did modify the test a little so that we could also actually run multiple incarnations of the test simultaneously, that is to generate the orphan stress operations on multiple files.  I have also attached the modified test, just in case.

These are the results that I got.

All values are real time in seconds, computed over ten runs with journaling disabled. "w/o" stand for without hashed mutexes and "with" for with mutexes, "Proc" number of processes, and "Files" number of files.


With only 1 file,

On an 8 core (16 thread) platform,


Proc |     1     |     20     |      40     |      80     |     160     |     400     |     800
----------------------------------------------------------------------------------------------------- 
     | Avg |  SD |  Avg |  SD |  Avg  |  SD |  Avg  | SD  |  Avg  |  SD |  Avg  | SD  |  Avg  | SD 
-----------------------------------------------------------------------------------------------------
w/o  |.7921|.0467|7.1342|.0316|12.4026|.3552|19.3930|.6917|22.7519|.7017|35.9374|1.658|66.7374|.4716
-----------------------------------------------------------------------------------------------------
with |.7819|.0362|6.3302|.2119|12.0933|.6589|18.7514|.9698|24.1351|1.659|38.6480|.6809|67.4810|.2749

On a 80 core (160 thread) platform,

Proc |      40      |      80      |      100      |      400      |       800     |     1600
----------------------------------------------------------------------------------------------------- 
     |  Avg  |  SD  |  Avg  |  SD  |  Avg   |  SD  |  Avg   |  SD  |   Avg  |  SD  |   Avg  |  SD 
-----------------------------------------------------------------------------------------------------
w/o  |44.8532|3.4991|67.8351|1.7534| 73.0616|2.4733|252.5798|1.1949|485.3289|5.7320|952.8874|2.0911
-----------------------------------------------------------------------------------------------------
with |46.1134|3.3228|99.1550|1.4894|109.0272|1.3617|259.6128|2.5247|284.4386|4.6767|266.8664|7.7726

With one file, we would expect without hashed mutexes would perform better than with.  The results do  show so on 80 core machine with 80 up to 400 processes.  Surprisingly there is no differences across all process ranges tested on 8 core.  Also on 80 core, with hashed mutexes the time seems to be steadying out at around high two hundred something with 400 or more processes and outperform without significantly with 800 or more processes.


With multiple files and only 1 process per file,

On an 8 core (16 thread) platform,


Proc |     40    |      80     |     150     |     400     |     800
-------------------------------------------------------------------------
     |  Avg |  SD |  Avg |  SD |  Avg  |  SD |  Avg  | SD  |  Avg  |  SD 
--------------------------------------------------------------------------
w/o  |3.3578|.0363|6.4533|.1204|12.1925|.2528|31.5862|.6016|63.9913|.3528
-------------------------------------------------------------------------
with |3.2583|.0384|6.3228|.1075|11.8328|.2290|30.5394|.3220|62.7672|.3802

On a 80 core (160 thread) platform,

Proc|      40      |      80      |      100      |     200      |   400     |      800     |     1200      |      1600
------------------------------------------------------------------------------------------------------------------ 
    |  Avg  |  SD  |  Avg  |  SD  |  Avg   |  SD  |  Avg  |  SD  |   Avg  |  SD |   Avg  |  SD  |  Avg   | SD   |
-------------------------------------------------------------------------------------------------------------------
w/o_|43.6507|2.9979|57.0404|1.8684|068.5557|1.2902|144.745|1.7939|52.7491|1.3585|487.8996|1.3997|715.1978|1.1224|942.5605|2.9629
-------------------------------------------------------------------------------------------------------------------
with|52.8003|2.1949|69.2455|1.2902|106.5026|1.8813|130.2995|7.8020150.3648|3.4153|184.7233|6.0525|270.1533|3.2261|298.5705|3.1318

Again, there is not much difference on 8 core.  On 80 core, without hashed mutexes performs better than with hashed mutexes with the number of files between 40 to less than 200.  With hashed mutexes outperorm without significantly with 400 or more files.

Overall there seems to be no performance difference on 8 core.  On 80 core with hashed mutexes, while performs worse than with in the lower ranges of both processes and files, seems to be scaling better with both higher processes and files.

Again, the change with hashed mutexes does include the additional optimization in orphan_add() introduced by your patch.  Please let me know if you need a copy of the modified patch with hashed mutexes for verification.

Thanks,
Mak.




--------------080808040107080107050708
Content-Type: text/x-csrc;
 name="stress_orphan.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="stress_orphan.c"

#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/shm.h>
#include <sys/times.h>
#include <stdint.h>

#define COUNT 100
#define MAX_PROCS 2048
#define MAX_ITERATIONS 2048
#define	SHM_FAILED	((void *) -1)
#define	NBPG	4096

char wbuf[4096];
int *g_mstart;

void run_test(char *base, int count)
{
	char pbuf[1024];
	int fd, i, j;

	sprintf(pbuf, "%s/file-%d", base, count);
	fd = open(pbuf, O_CREAT | O_TRUNC | O_WRONLY, 0644);
	if (fd < 0) {
		perror("open");
		exit(1);
	}
	
	for (i = 0; i < COUNT; i++) {
		if (pwrite(fd, wbuf, 4096, 0) != 4096) {
			perror("pwrite");
			exit(1);
		}

		for (j = 4095; j >= 1; j--) {
			if (ftruncate(fd, j) < 0) {
				perror("ftruncate");
				exit(1);
			}
		}
	}
}

int run_main(int procs, char *basedir)
{
	int i, j;
	pid_t pids[MAX_PROCS];
	clock_t start_clock;
	struct tms start_times;
	clock_t end_clock;
	struct tms end_times;

	while (!*g_mstart);

	start_clock = times(&start_times);

	for (i = 0; i < procs; i++) {
		pids[i] = fork();
		if (pids[i] < 0) {
			perror("fork");
			for (j = 0; j < i; j++)
				kill(pids[j], SIGKILL);
			return 1;
		}
		if (pids[i] == 0) {
			run_test(basedir, i);
			exit(0);
		}
	}

#ifdef	PRINT_TIMES
	printf("Processes started for %s.\n", basedir);
#endif	/* PRINT_TIMES */
	for (i = 0; i < procs; i++)
		waitpid(pids[i], NULL, 0);
	end_clock = times(&end_times);

#ifdef	PRINT_TIMES
	printf("Real Time: %jd User Time %jd System Time %jd.\n",
		(intmax_t)(end_clock - start_clock),
		(intmax_t)(end_times.tms_utime - start_times.tms_utime),
		(intmax_t)(end_times.tms_stime - start_times.tms_stime));
	fflush(stdout);
#endif	/* PRINT_TIMES */
	return 0;
}

int main(int argc, char **argv)
{
	int procs, i, j;
	pid_t mpids[MAX_ITERATIONS];
	int niterations = 10;
	char basedir[64];
	int n, shmid;

	if (argc < 3) {
		fprintf(stderr, "Usage: stress-orphan <processes> <dir>"
			" [<iterations>]\n");
		return 1;
	}
	if (argc > 3) {
		niterations = atoi(argv[3]);
		if (niterations > MAX_ITERATIONS) {
			fprintf(stderr, "Warning: iterations %d > "
				" MAX %d.\n",
				niterations, MAX_ITERATIONS);
			niterations = MAX_ITERATIONS;
		}
	}

	if ((shmid = shmget(IPC_PRIVATE, NBPG, 0600)) < 0) {
		fprintf(stderr, "Error in shmget, errno %d.\n", errno);
		return 1;
	}

	if ((g_mstart = (int *)shmat(shmid, 0, 0)) == SHM_FAILED) {
		fprintf(stderr, "Error in shmat, errno %d.\n", errno);
		return 1;
	}
	*g_mstart = 0;

	procs = strtol(argv[1], NULL, 10);
	if (procs > MAX_PROCS) {
		fprintf(stderr, "Too many processes!\n");
		return 1;
	}

	strcpy(basedir, argv[2]);
	n = strlen(basedir);
	for ( i = 0 ; i < niterations ; i++ ) {
		sprintf(&basedir[n], "%d", i + 1);
		mpids[i] = fork();
		if (mpids[i] < 0) {
			perror("fork");
			for (j = 0; j < i; j++)
				kill(mpids[j], SIGKILL);
			return 1;
		}
		if (mpids[i] == 0) {
			run_main(procs, basedir);
			exit(0);
		}
	}

	printf("Main started for %d %s %d.\n", procs,
		basedir, niterations);
	*g_mstart = 1;

	for (i = 0; i < niterations ; i++)
		waitpid(mpids[i], NULL, 0);
	printf("Main Processes Done.\n");
}


--------------080808040107080107050708--
