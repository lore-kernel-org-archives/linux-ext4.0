From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Wed, 23 Jul 2014 10:15:40 +0200
Message-ID: <20140723081539.GB15688@quack.suse.cz>
References: <1400185026-3972-3-git-send-email-jack@suse.cz>
 <537B1353.8060704@hp.com>
 <20140520135723.GB15177@thunk.org>
 <538CB83C.9080409@hp.com>
 <20140603085205.GA29219@quack.suse.cz>
 <539F4380.5090001@hp.com>
 <20140617092932.GB8622@quack.suse.cz>
 <53A117C8.3000207@hp.com>
 <20140618103738.GA16162@quack.suse.cz>
 <53CDEA0C.6060400@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaGWIPo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jul 2014 04:15:44 -0400
Content-Disposition: inline
In-Reply-To: <53CDEA0C.6060400@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Mon 21-07-14 22:35:24, Thavatchai Makphaibulchoke wrote:
> On 06/18/2014 04:37 AM, Jan Kara wrote:
> >   That's not true. The original test program creates one file per process:
> > void run_test(char *base, int count)
> > {
> > ...
> >        sprintf(pbuf, "%s/file-%d", base, count);
> >        fd = open(pbuf, O_CREAT | O_TRUNC | O_WRONLY, 0644);
> > ...
> >   and forks given number of processes. Ah, maybe I see what you are getting
> > at. My original test program doesn't bother with synchronizing start of the
> > processes - I have manually set number of repetitions (COUNT) so that each
> > process runs long enough on my machine that the differences in start time
> > are negligible.  Maybe you thought these processes run sequentially (and
> > maybe they really did if you had fast enough setup). So I agree
> > synchronization of start using shared memory as you did it is a good thing
> > and gets more reliable numbers especially for high numbers of processes
> > (which I didn't really test because of my limited HW) just there's no need
> > to add another level of iteration...
> > 
> First sorry for taking a little long to get back.
> 
> Your original main is now my new run_main() function.  The old main and
> new run_main() function, practically are doing the same thing, fork and
> immediately all the child processes as indicated by argv[1], running the
> original run_test() function.  By converting it to a run_main function,
> I'm trying to start each incarnation of the old main as closed to each
> other as possible, making sure I have some overlapping orphan activities
> on different files.  Actually I should have done the synchronization in
> the run_test function instead, this way both tests should be closer to
> each other.
> 
> Here are the results with 3.15-rc5 baseline kernel, using your original
> test.  Each result is an average over ten runs, except those longer runs,
> marked with an '*', which is an average of only 5 runs.
> 
> On a 2 socket 16 thread machine,
> 
>             ----------------------------------
>  Num files  |   40  |  100  |  400  |  1000  |
> ----------------------------------------------
> |W/O Mutexes|118.593|178.118|595.017|1480.165|
> -----------------------------------------------
> |W Mutexes  |129.212|194.728|620.412|1430.908|
> ----------------------------------------------
> 
> On an 8 socket 160 thread machine,
> 
>             --------------------------------------------
>  Num files  |   40  |  100  |   400  |  1000* |  1500* |
> -------------------------------------------------------
> |W/O Mutexes|387.257|644.270|1692.018|4254.766|7362.064|
> -------------------------------------------------------
> |W Mutexes  |328.490|557.508|1967.676|4721.060|7013.618|
> --------------------------------------------------------
> 
> From the above data, looks like without mutexes (WOM) performs better
> across the board on a smaller machine, except at 1000 files.  For a
> larger machine, I give the edge to with mutexes (WM) for smaller number
> of files, until around 400 to 100 something files.  Looks like with WOM
> starts performing better again at 1500 files.
> 
  
<snip results for larger truncates as those don't seem to show anything
new>

> Here are also aim7 results on an 8 socket 160 threads machine, at 2000
> users,
> 
>            | % of Average job per minutes of WM compared to WOM
> ----------------------------------------------------------------
> all_tests  | +42.02%
> ----------------------------------------------------------------
> custom     | +56.22%
> ----------------------------------------------------------------
> dbase      |      0%
> ----------------------------------------------------------------
> disk       |      0%
> ----------------------------------------------------------------
> fserver    | +51.23%
> ----------------------------------------------------------------
> new_dbase  |      0%
> ----------------------------------------------------------------
> new_fserver|+53.83%
> ----------------------------------------------------------------
> shared     |+44.37%
> ----------------------------------------------------------------
> 
> Please let me know if you have need any additional info or have any
> question and also if you would like a copy of the patch for testing.
  Thanks for all the measurements! I don't have further questions I think.
All your tests seem to point to the fact that when contention on orphan
list is high, your hashed mutexes improve performance (especially when we
are bouncing cache between sockets) while they have some cost for low
contention cases. I'm not sure it is a worthwhile tradeoff but it's upto
Ted as a maintainer to decide.

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
