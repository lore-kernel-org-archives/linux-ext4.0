From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Wed, 18 Jun 2014 12:37:38 +0200
Message-ID: <20140618103738.GA16162@quack.suse.cz>
References: <1400185026-3972-1-git-send-email-jack@suse.cz>
 <1400185026-3972-3-git-send-email-jack@suse.cz>
 <537B1353.8060704@hp.com>
 <20140520135723.GB15177@thunk.org>
 <538CB83C.9080409@hp.com>
 <20140603085205.GA29219@quack.suse.cz>
 <539F4380.5090001@hp.com>
 <20140617092932.GB8622@quack.suse.cz>
 <53A117C8.3000207@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966172AbaFRKho (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Jun 2014 06:37:44 -0400
Content-Disposition: inline
In-Reply-To: <53A117C8.3000207@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 17-06-14 22:38:32, Thavatchai Makphaibulchoke wrote:
> On 06/17/2014 03:29 AM, Jan Kara wrote:
> >   Hum, looking at your test program source I'm not sure what do you mean.
> > Your program first forks 'niteration' times and each process starts using a
> > different directory. Then each of these processes forks 'procs' times and
> > each of these processes will use a different file in the directory
> > belonging to the parent. So what's the difference to just running
> > 'niterations' * 'procs' processes? After some thought I guess the
> > difference is in how time to run on each individual file contributes to the
> > total average -
> >   (\sum_{i=1}^{procs} t_i)/procs
> > in the first case you ran, where t_i is the time to run test for file i, and
> >   (max^{i=1}^{procs} t_i)
> > in the second case. But what's the point?
> > 
> 
> The original test program generates orphan traffic on only a single file,
> which not only does not seem to be a fair comparison for the WM (with
> hashed mutexes) algorithm, does not seem to represent realistic load.
> The modified test's intention is to compare performance between the WM
> and WO (without hashed mutexes) under heavy orphan traffic on more than a
> single file.
  That's not true. The original test program creates one file per process:
void run_test(char *base, int count)
{
...
       sprintf(pbuf, "%s/file-%d", base, count);
       fd = open(pbuf, O_CREAT | O_TRUNC | O_WRONLY, 0644);
...
  and forks given number of processes. Ah, maybe I see what you are getting
at. My original test program doesn't bother with synchronizing start of the
processes - I have manually set number of repetitions (COUNT) so that each
process runs long enough on my machine that the differences in start time
are negligible.  Maybe you thought these processes run sequentially (and
maybe they really did if you had fast enough setup). So I agree
synchronization of start using shared memory as you did it is a good thing
and gets more reliable numbers especially for high numbers of processes
(which I didn't really test because of my limited HW) just there's no need
to add another level of iteration...

> Instead of running multiple copies of the original test in the background
> (for a short job we may not actually get overlapping traffic on different
> inodes), the modified test runs and start the excution, as close as
> possible to each other, of multiple copies of the original test.
> 
> The results of my test is the average, over ten runs, of the maximum time
> the original test takes to complete under certain number of processes and
> files.  Of course, with one copy (niteration of 1), we get the
> equivalence of the original test.
> 
> >   What do you exactly mean by 'journaling disabled'? Did you run ext4 in
> > nojournal mode? That wouldn't really make sense because in nojournal mode
> > all orphan list operations are skipped... So what did you really test?
> > 
> 
> Yes, sorry my fault disabling journaling, should also inhibit the orphan
> activities.  Therefore there should not be any difference in performance
> between the two.
  Exactly, it's strange you saw a difference.

> I just discovered that the two different branches I used do not have the
> same baseline.  Let me recreate the two branches and redo my test.  I'll
> get back with you with the results.
  OK, looking forward to the results.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
