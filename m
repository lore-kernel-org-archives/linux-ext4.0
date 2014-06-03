From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Tue, 3 Jun 2014 10:52:05 +0200
Message-ID: <20140603085205.GA29219@quack.suse.cz>
References: <1400185026-3972-1-git-send-email-jack@suse.cz>
 <1400185026-3972-3-git-send-email-jack@suse.cz>
 <537B1353.8060704@hp.com>
 <20140520135723.GB15177@thunk.org>
 <538CB83C.9080409@hp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaFCIwK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jun 2014 04:52:10 -0400
Content-Disposition: inline
In-Reply-To: <538CB83C.9080409@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 02-06-14 11:45:32, Thavatchai Makphaibulchoke wrote:
> On 05/20/2014 07:57 AM, Theodore Ts'o wrote:
> > On Tue, May 20, 2014 at 02:33:23AM -0600, Thavatchai Makphaibulchoke wrote:
> > 
> > Thavatchai, it would be really great if you could do lock_stat runs
> > with both Jan's latest patches as well as yours.  We need to
> > understand where the differences are coming from.
> > 
> > As I understand things, there are two differences between Jan and your
> > approaches.  The first is that Jan is using the implicit locking of
> > i_mutex to avoid needing to keep a hashed array of mutexes to
> > synchronize an individual inode's being added or removed to the orphan
> > list.
> > 
> > The second is that you've split the orphan mutex into an on-disk mutex
> > and a in-memory spinlock.
> > 
> > Is it possible to split up your patch so we can measure the benefits
> > of each of these two changes?  More interestingly, is there a way we
> > can use the your second change in concert with Jan's changes?
> > 
> > Regards,
> > 
> > 						- Ted
> > 
> 
> Thanks to Jan, as she pointed out one optimization in orphan_addr() that
> I've missed.
> 
> After integrated that into my patch, I've rerun the following aim7
> workloads; alltests, custom, dbase, disk, fserver, new_fserver, shared
> and short.  Here are the results.
> 
> On an 8 core (16 thread) machine, both my revised patch (with additional
> optimization from Jan's oprhan_add()) and version 3 of Jan's patch give
> about the same results, for most of the workloads, except fserver and
> new_fserver, which Jan's outperforms about 9% and 16%, respectively.
> 
> Here are the lock_stat output for disk,
> Jan's patch,
> lock_stat version 0.4
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>                               class name    con-bounces    contentions   waittime-min   waittime-max waittime-total   waittime-avg    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total   holdtime-avg
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>                      &sbi->s_orphan_lock:         80189          80246           3.94      464489.22    77219615.47         962.29         503289         809004           0.10      476537.44     3424587.77           4.23
> Mine,
>                      &sbi->s_orphan_lock:         82215          82259           3.61      640876.19    15098561.09         183.55         541422         794254           0.10      640368.86     4425140.61           5.57
>               &sbi->s_orphan_op_mutex[n]:        102507         104880           4.21     1335087.21  1392773487.19       13279.69         398328         840120           0.11     1334711.17   397596137.90         473.26
> 
> For new_fserver,
> Jan's patch,
>                      &sbi->s_orphan_lock:       1063059        1063369           5.57     1073325.95 59535205188.94       55987.34        4525570        8446052           0.10       75625.72    10700844.58         1.27
> Mine,
>                      &sbi->s_orphan_lock:       1171433        1172220           3.02      349678.21   553168029.92         471.90        5517262        8446052           0.09      254108.75    16504015.29           1.95
>               &sbi->s_orphan_op_mutex[n]:       2176760        2202674           3.44      633129.10 55206091750.06       25063.21        3259467        8452918           0.10      349687.82   605683982.34        71.65
> 
> 
> On an 80 core (160 thread) machine, mine outpeforms Jan's in alltests,
> custom, fserver, new_fserver and shared about the same margin it did over
> the baseline, around 20%   For all these workloads, Jan's patch does not
> seem to show any noticeable improvement over baseline kernel.  I'm
> getting about the same performance with the rest of the workloads.
> 
> Here are the lock_stat output for alltests,
> Jan;'s,
>                      &sbi->s_orphan_lock:       2762871        2763355           4.46       49043.39  1763499587.40         638.17        5878253        6475844           0.15       20508.98    70827300.79          10.94
> Mine,
>                        &sbi->s_orphan_lock:       1171433        1172220           3.02      349678.21   553168029.92         471.90        5517262        8446052           0.09      254108.75    16504015.29           1.95
>               &sbi->s_orphan_op_mutex[n]:        783176         785840           4.95       30358.58   432279688.66         550.09        2899889        6505883           0.16       30254.12  1668330140.08         256.43
> 
> For custom,
> Jan's,
>                      &sbi->s_orphan_lock:       5706466        5707069           4.54       44063.38  3312864313.18         580.48       11942088       13175060           0.15       15944.34   142660367.51          10.83
> Mine,
>                      &sbi->s_orphan_lock:       5518186        5518558           4.84       32040.05  2436898419.22         441.58       12290996       13175234           0.17       23160.65   141234888.88          10.72
>               &sbi->s_orphan_op_mutex[n]:       1565216        1569333           4.50       32527.02   788215876.94         502.26        5894074       13196979           0.16       71073.57  3128766227.92         237.08
> 
> For dbase,
> Jan's,
>                      &sbi->s_orphan_lock:         14453          14489           5.84       39442.57     8678179.21         598.95         119847         153686           0.17        4390.25     1406816.03           9.15
> Mine,
>                      &sbi->s_orphan_lock:         13847          13868           6.23       31314.03     7982386.22         575.60         120332         153542           0.17        9354.86     1458061.28           9.50
>               &sbi->s_orphan_op_mutex[n]:          1700           1717          22.00       50566.24     1225749.82         713.89          85062         189435           0.16       31374.44    14476217.56          76.42
> 
> In case the line-wrap making it hard to read, I've also attached the
> results as a text file.
> 
> The lock_stat seems to show that with my patch the s_orphan_lock performs
> better across the board.  But on a smaller machine, the hashed mutex
> seems to offset out the performance gain in the s_oprhan_lock and
> increase the hashed mutex size likely to make it perform better.
  I'd interpret the data a bit differently :) With your patch the
contention for resource - access to orphan list - is split between
s_orphan_lock and s_orphan_op_mutex. For the smaller machine contending
directly on s_orphan_lock is a win and we spend less time waiting in total.
For the large machine it seems beneficial to contend on the hashed mutex
first and only after that on global lock. Likely that reduces amount of
cacheline bouncing, or maybe the mutex is more often acquired during the
spinning phase which reduces the acquisition latency.

> Jan, if you could send me your orphan stress test, I could run lock_stat
> for more performance comparison.
  Sure, it is attached.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--DocE+STaALJfprDB
Content-Type: text/x-c; charset=us-ascii
Content-Disposition: attachment; filename="stress-orphan.c"

#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>

#define COUNT 100
#define MAX_PROCS 1024

char wbuf[4096];

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

int main(int argc, char **argv)
{
	int procs, i, j;
	pid_t pids[MAX_PROCS];

	if (argc != 3) {
		fprintf(stderr, "Usage: stress-orphan <processes> <dir>\n");
		return 1;
	}
	procs = strtol(argv[1], NULL, 10);
	if (procs > MAX_PROCS) {
		fprintf(stderr, "Too many processes!\n");
		return 1;
	}

	for (i = 0; i < procs; i++) {
		pids[i] = fork();
		if (pids[i] < 0) {
			perror("fork");
			for (j = 0; j < i; j++)
				kill(pids[j], SIGKILL);
			return 1;
		}
		if (pids[i] == 0) {
			run_test(argv[2], i);
			exit(0);
		}
	}

	printf("Processes started.\n");
	for (i = 0; i < procs; i++)
		waitpid(pids[i], NULL, 0);
	return 0;
}

--DocE+STaALJfprDB--
