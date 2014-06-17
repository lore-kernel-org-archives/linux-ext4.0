From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Tue, 17 Jun 2014 11:29:32 +0200
Message-ID: <20140617092932.GB8622@quack.suse.cz>
References: <1400185026-3972-1-git-send-email-jack@suse.cz>
 <1400185026-3972-3-git-send-email-jack@suse.cz>
 <537B1353.8060704@hp.com>
 <20140520135723.GB15177@thunk.org>
 <538CB83C.9080409@hp.com>
 <20140603085205.GA29219@quack.suse.cz>
 <539F4380.5090001@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263AbaFQJ3h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2014 05:29:37 -0400
Content-Disposition: inline
In-Reply-To: <539F4380.5090001@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 16-06-14 13:20:32, Thavatchai Makphaibulchoke wrote:
> On 06/03/2014 02:52 AM, Jan Kara wrote:
> >   I'd interpret the data a bit differently :) With your patch the
> > contention for resource - access to orphan list - is split between
> > s_orphan_lock and s_orphan_op_mutex. For the smaller machine contending
> > directly on s_orphan_lock is a win and we spend less time waiting in total.
> > For the large machine it seems beneficial to contend on the hashed mutex
> > first and only after that on global lock. Likely that reduces amount of
> > cacheline bouncing, or maybe the mutex is more often acquired during the
> > spinning phase which reduces the acquisition latency.
> > 
> >   Sure, it is attached.
> > 
> > 								Honza
> > 
> 
> Thanks Jan for the test program.
> 
> Anyway I did modify the test a little so that we could also actually run
> multiple incarnations of the test simultaneously, that is to generate the
> orphan stress operations on multiple files.  I have also attached the
> modified test, just in case.
  Hum, looking at your test program source I'm not sure what do you mean.
Your program first forks 'niteration' times and each process starts using a
different directory. Then each of these processes forks 'procs' times and
each of these processes will use a different file in the directory
belonging to the parent. So what's the difference to just running
'niterations' * 'procs' processes? After some thought I guess the
difference is in how time to run on each individual file contributes to the
total average -
  (\sum_{i=1}^{procs} t_i)/procs
in the first case you ran, where t_i is the time to run test for file i, and
  (max^{i=1}^{procs} t_i)
in the second case. But what's the point?

> These are the results that I got.
> 
> All values are real time in seconds, computed over ten runs with
> journaling disabled. "w/o" stand for without hashed mutexes and "with"
> for with mutexes, "Proc" number of processes, and "Files" number of
> files.
  What do you exactly mean by 'journaling disabled'? Did you run ext4 in
nojournal mode? That wouldn't really make sense because in nojournal mode
all orphan list operations are skipped... So what did you really test?

> With only 1 file,
> 
> On an 8 core (16 thread) platform,
> 
> 
> Proc |     1     |     20     |      40     |      80     |     160     |     400     |     800
> ----------------------------------------------------------------------------------------------------- 
>      | Avg |  SD |  Avg |  SD |  Avg  |  SD |  Avg  | SD  |  Avg  |  SD |  Avg  | SD  |  Avg  | SD 
> -----------------------------------------------------------------------------------------------------
> w/o  |.7921|.0467|7.1342|.0316|12.4026|.3552|19.3930|.6917|22.7519|.7017|35.9374|1.658|66.7374|.4716
> -----------------------------------------------------------------------------------------------------
> with |.7819|.0362|6.3302|.2119|12.0933|.6589|18.7514|.9698|24.1351|1.659|38.6480|.6809|67.4810|.2749
> 
> On a 80 core (160 thread) platform,
> 
> Proc |      40      |      80      |      100      |      400      |       800     |     1600
> ----------------------------------------------------------------------------------------------------- 
>      |  Avg  |  SD  |  Avg  |  SD  |  Avg   |  SD  |  Avg   |  SD  |   Avg  |  SD  |   Avg  |  SD 
> -----------------------------------------------------------------------------------------------------
> w/o  |44.8532|3.4991|67.8351|1.7534| 73.0616|2.4733|252.5798|1.1949|485.3289|5.7320|952.8874|2.0911
> -----------------------------------------------------------------------------------------------------
> with |46.1134|3.3228|99.1550|1.4894|109.0272|1.3617|259.6128|2.5247|284.4386|4.6767|266.8664|7.7726
> 
> With one file, we would expect without hashed mutexes would perform
> better than with.  The results do  show so on 80 core machine with 80 up
> to 400 processes.  Surprisingly there is no differences across all
> process ranges tested on 8 core.  Also on 80 core, with hashed mutexes
> the time seems to be steadying out at around high two hundred something
> with 400 or more processes and outperform without significantly with 800
> or more processes.
> 
> With multiple files and only 1 process per file,
> 
> On an 8 core (16 thread) platform,
> 
> 
> Proc |     40    |      80     |     150     |     400     |     800
> -------------------------------------------------------------------------
>      |  Avg |  SD |  Avg |  SD |  Avg  |  SD |  Avg  | SD  |  Avg  |  SD 
> --------------------------------------------------------------------------
> w/o  |3.3578|.0363|6.4533|.1204|12.1925|.2528|31.5862|.6016|63.9913|.3528
> -------------------------------------------------------------------------
> with |3.2583|.0384|6.3228|.1075|11.8328|.2290|30.5394|.3220|62.7672|.3802
> 
> On a 80 core (160 thread) platform,
> 
> Proc|      40      |      80      |      100      |     200      |   400     |      800     |     1200      |      1600
> ------------------------------------------------------------------------------------------------------------------ 
>     |  Avg  |  SD  |  Avg  |  SD  |  Avg   |  SD  |  Avg  |  SD  |   Avg  |  SD |   Avg  |  SD  |  Avg   | SD   |
> -------------------------------------------------------------------------------------------------------------------
> w/o_|43.6507|2.9979|57.0404|1.8684|068.5557|1.2902|144.745|1.7939|52.7491|1.3585|487.8996|1.3997|715.1978|1.1224|942.5605|2.9629
                                                                    ^^^^
							this number is strange
> -------------------------------------------------------------------------------------------------------------------
> with|52.8003|2.1949|69.2455|1.2902|106.5026|1.8813|130.2995|7.8020150.3648|3.4153|184.7233|6.0525|270.1533|3.2261|298.5705|3.1318
> 
> Again, there is not much difference on 8 core.  On 80 core, without
> hashed mutexes performs better than with hashed mutexes with the number
> of files between 40 to less than 200.  With hashed mutexes outperorm
> without significantly with 400 or more files.
> 
> Overall there seems to be no performance difference on 8 core.  On 80
> core with hashed mutexes, while performs worse than with in the lower
> ranges of both processes and files, seems to be scaling better with both
> higher processes and files.
  Your numbers are interesting and seem to confirm that with really high
contention it is advantageous to contend on smaller locks first (your
hashed mutexes) and only after that on the global lock. But I'd like to
hear answers to my previous questions before drawing any conclusions...
 
> Again, the change with hashed mutexes does include the additional
> optimization in orphan_add() introduced by your patch.  Please let me
> know if you need a copy of the modified patch with hashed mutexes for
> verification.
  

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
