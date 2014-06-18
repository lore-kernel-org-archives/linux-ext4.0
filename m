From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Tue, 17 Jun 2014 22:38:32 -0600
Message-ID: <53A117C8.3000207@hp.com>
References: <1400185026-3972-1-git-send-email-jack@suse.cz> <1400185026-3972-3-git-send-email-jack@suse.cz> <537B1353.8060704@hp.com> <20140520135723.GB15177@thunk.org> <538CB83C.9080409@hp.com> <20140603085205.GA29219@quack.suse.cz> <539F4380.5090001@hp.com> <20140617092932.GB8622@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g2t2352.austin.hp.com ([15.217.128.51]:29979 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbaFREls (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jun 2014 00:41:48 -0400
In-Reply-To: <20140617092932.GB8622@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/17/2014 03:29 AM, Jan Kara wrote:
>   Hum, looking at your test program source I'm not sure what do you mean.
> Your program first forks 'niteration' times and each process starts using a
> different directory. Then each of these processes forks 'procs' times and
> each of these processes will use a different file in the directory
> belonging to the parent. So what's the difference to just running
> 'niterations' * 'procs' processes? After some thought I guess the
> difference is in how time to run on each individual file contributes to the
> total average -
>   (\sum_{i=1}^{procs} t_i)/procs
> in the first case you ran, where t_i is the time to run test for file i, and
>   (max^{i=1}^{procs} t_i)
> in the second case. But what's the point?
> 

The original test program generates orphan traffic on only a single file, which not only does not seem to be a fair comparison for the WM (with hashed mutexes) algorithm, does not seem to represent realistic load.  The modified test's intention is to compare performance between the WM and WO (without hashed mutexes) under heavy orphan traffic on more than a single file.

Instead of running multiple copies of the original test in the background (for a short job we may not actually get overlapping traffic on different inodes), the modified test runs and start the excution, as close as possible to each other, of multiple copies of the original test.

The results of my test is the average, over ten runs, of the maximum time the original test takes to complete under certain number of processes and files.  Of course, with one copy (niteration of 1), we get the equivalence of the original test.

>   What do you exactly mean by 'journaling disabled'? Did you run ext4 in
> nojournal mode? That wouldn't really make sense because in nojournal mode
> all orphan list operations are skipped... So what did you really test?
> 

Yes, sorry my fault disabling journaling, should also inhibit the orphan activities.  Therefore there should not be any difference in performance between the two.

I just discovered that the two different branches I used do not have the same baseline.  Let me recreate the two branches and redo my test.  I'll get back with you with the results.

Sorry for the confusion.

Thanks,
Mak.


>   Your numbers are interesting and seem to confirm that with really high
> contention it is advantageous to contend on smaller locks first (your
> hashed mutexes) and only after that on the global lock. But I'd like to
> hear answers to my previous questions before drawing any conclusions...
>  
>   
> 
> 								Honza
> 


