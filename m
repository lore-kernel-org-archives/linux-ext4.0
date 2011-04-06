From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Wed, 6 Apr 2011 19:46:17 +0200
Message-ID: <20110406174617.GC28689@quack.suse.cz>
References: <4D5C9B1B.2050304@jp.fujitsu.com>
 <20110217104552.GD4947@quack.suse.cz>
 <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com>
 <20110330141205.GC22349@quack.suse.cz>
 <4D946DAB.3010107@jp.fujitsu.com>
 <4D9AEE28.4000003@jp.fujitsu.com>
 <20110405225428.GD8531@quack.suse.cz>
 <4D9BF57A.6030705@jp.fujitsu.com>
 <20110406055708.GB23285@quack.suse.cz>
 <4D9C18DF.90803@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1DFRqV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Apr 2011 13:46:21 -0400
Content-Disposition: inline
In-Reply-To: <4D9C18DF.90803@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Wed 06-04-11 16:40:15, Toshiyuki Okajima wrote:
> (2011/04/06 14:57), Jan Kara wrote:
> >On Wed 06-04-11 14:09:14, Toshiyuki Okajima wrote:
> >>(2011/04/06 7:54), Jan Kara wrote:
> >>>On Tue 05-04-11 19:25:44, Toshiyuki Okajima wrote:
> >>>>(2011/03/31 21:03), Toshiyuki Okajima wrote:
> >>>>>Hi, thanks for your reviewing.
> >>>>>
> >>>>>(2011/03/30 23:12), Jan Kara wrote:
> >>>>>>Hello,
> >>>>>>
> >>>>>>On Mon 28-03-11 17:06:28, Toshiyuki Okajima wrote:
> >>>>>>>On Thu, 17 Feb 2011 11:45:52 +0100
> >>>>>>>Jan Kara<jack@suse.cz>   wrote:
> >>>>>>>>On Thu 17-02-11 12:50:51, Toshiyuki Okajima wrote:
> >>>>>>>>>(2011/02/16 23:56), Jan Kara wrote:
> >>>>>>>>>>On Wed 16-02-11 08:17:46, Toshiyuki Okajima wrote:
> >>>>>>>>>>>On Tue, 15 Feb 2011 18:29:54 +0100
> >>>>>>>>>>>Jan Kara<jack@suse.cz>   wrote:
> >>>>>>>>>>>>On Tue 15-02-11 12:03:52, Ted Ts'o wrote:
> >>>>>>>>>>>>>On Tue, Feb 15, 2011 at 05:06:30PM +0100, Jan Kara wrote:
> >>>>><SNIP>
> >>>>>>>I have deeply continued to examined the root cause of this problem, then
> >>>>>>>I found it.
> >>>>>>>
> >>>>>>>It is that we can write a memory which is mmaped to a file. Then the memory
> >>>>>>>becomes "DIRTY" so then the flusher thread (ex. wb_do_writeback) tries to
> >>>>>>>"writeback" the memory.
> >>>>>>>
> >>>>>>>Therefore, the root cause of this hangup is not only ext4 component (with
> >>>>>>>delayed allocation feature) but also writeback mechanism for mmap. If you
> >>>>>>>use the other filesystem, you can write something to the filesystem though
> >>>>>>>you have freezed the filesystem.
> >>>>>
> >>>>>>Well, you can write something only in the caches, not to the on disk
> >>>>>>image. So it's not a problem as such.
> >>>>>My reproducer uses the loopback device(/dev/loopX). By using it, I have confirmed that
> >>>>>we can write in not only the caches but also the loopback device. However,
> >>>>>I don't still confirm that we can write to the real device(/dev/sdaX).
> >>>>>
> >>>>>>
> >>>>>>>A sample problem is attached on this mail. Try to execute it then you can
> >>>>>>>confirm that we can write some data to your filesystem while freezing the
> >>>>>>>filesystem.
> >>>>>>>(If you change FS variable in go.sh from ext3 to ext4 and you execute
> >>>>>>>"fsfreeze -u mnt" manually on other prompt, you can also confirm this deadlock.)
> >>>>>>>
> >>>>>>>I think the best approach to fix this problem is to let users not to write
> >>>>>>>memory which is mapped to a certain file while the filesystem is freezing.
> >>>>>>>However, it is very difficult to control users not to write memory which has
> >>>>>>>been already mapped to the file.
> >>>>>>It is actually possible. In case of ext4, you could add a check (+ wait)
> >>>>>>in ext4_page_mkwrite() whether the filesystem is frozen or in the process
> >>>>>>of being frozen and if so, wait for it to get unfrozen. The only tough
> >>>>>>problem here might be the locking as ext4_page_mkwrite() is called with
> >>>>>>mmap_sem held and I'm not sure we can take s_umount with mmap_sem held.
> >>>>>>But you'd have to fix all filesystems (and all paths possibly creating
> >>>>>>dirty data) in this way.
> >>>>>>
> >>>>>
> >>>>>>>Therefore, I think there is only actual method that we stop writeback thread
> >>>>>>>to resolve the mmap problem. Also, by this fix, the original problem
> >>>>>>>(ext4 delayed write vs unfreeze) can be solved.
> >>>>>>Hmm, I had a look at the code again and think we could fix the issue
> >>>>>>cleanly (i.e. all possible users of s_umount) as follows: The lock
> >>>>>>ordering will be
> >>>>>>s_umount ->   "fs frozen"
> >>>>>>and there will be a new mutex s_freeze_mutex protecting changes of
> >>>>>>s_frozen.
> >>>>>>
> >>>>>>freeze_bdev() already observes this lock ordering, it will only take
> >>>>>>s_freeze_mutex for the changes of s_frozen values. The only other code
> >>>>>>that is relevant for the lock ordering is thaw_super() (the freezing
> >>>>>>process is not expected to reenter kernel for the frozen filesystem).
> >>>>>>In thaw_super() we could take s_freeze_mutex, do all the thawing work,
> >>>>>>set s_frozen, release s_freeze_mutex and put superblock reference.
> >>>>>>
> >>>>>
> >>>>>>So something like the patch below - it seems to work for me, can you test
> >>>>>>it please?
> >>>>>I think your patch looks good, so, the original problem seems to be solved.
> >>>>>OK, I will test your patch.
> >>>>>This weekend I cannot test it. So, I will reply next week.
> >>>>I have tested whether Mizuma-san's reproducer can cause to deadlock with your
> >>>>patch. And then any problems didn't hit while the reproducer was running.
> >>>>
> >>>>I think your patch solves the original deadlock problem which is reported by
> >>>>Mizuma-san.
> >>>   Good. Thanks.
> >>>
> >>>>>Reported-by: Toshiyuki Okajima<toshi.okajima@jp.fujitsu.com>
> >>>>>Signed-off-by: Jan Kara<jack@suse.cz>
> >>>>>---
> >>>>>fs/super.c         |   40 ++++++++++++++++++++++++++++++++++------
> >>>>>include/linux/fs.h |    1 +
> >>>>>2 files changed, 35 insertions(+), 6 deletions(-)
> >>>>
> >>
> >>>>However, I think a write which causes the deadlock is from mmapped dirty
> >>>>pages. So, I guess we also need to fix in the mmap path while fsfreezing.
> >>>   Why? If you dirty a page, writeback thread can come and try to write it -
> >>>which blocks - but now that does not matter...
> 
> >>I have not understood the code around writeback thread very much...
> >>Please explain me the concrete function name which blocks some writes?
> >   It would block in ext4_da_writepages() function.
> In ext4 with delayed allocation case, I understand it blocks.
> (Original deadlock problem is just this case.)
> But in ext4 without delayed allocation or other filesystems case, which function
> can block writing?
  For ext3 or ext4 without delayed allocation we block inside writepage()
function. But as I wrote to Dave Chinner, ->page_mkwrite() should probably
get modified to block while minor-faulting the page on frozen fs because
when blocks are already allocated we may skip starting a transaction and so
we could possibly modify the filesystem.

> >>Mizuma-san's reproducer also writes the data which maps to the file (mmap).
> >>The original problem happens after the fsfreeze operation is done.
> >>I understand the normal write operation (not mmap) can be blocked while
> >>fsfreezing. So, I guess we don't always block all the write operation
> >>while fsfreezing.
> >   Technically speaking, we block all the transaction starts which means we
> >end up blocking all the writes from going to disk. But that does not mean
> >we block all the writes from going to in-memory cache - as you properly
> >note the mmap case is one of such exceptions.
> Hm, I also think we can allow the writes to in-memory cache but we can't allow
> the writes to disk while fsfreezing. I am considering that mmap path can
> write to disk while fsfreezing because this deadlock problem happens after
> fsfreeze operation is done...
  I'm sorry I don't understand now - are you speaking about the case above
when writepage() does not wait for filesystem being frozen or something
else?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
