From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [RFC] do you want jbd2 interface of ext3?
Date: Fri, 26 Feb 2010 16:25:23 +0900
Message-ID: <20100226162523.7c61f619.toshi.okajima@jp.fujitsu.com>
References: <20100216164123.b10b00e5.toshi.okajima@jp.fujitsu.com>
	<20100216185452.GE3153@quack.suse.cz>
	<4B7BAA70.9070605@jp.fujitsu.com>
	<20100217164933.GC5337@thunk.org>
	<4B8219B8.8070207@jp.fujitsu.com>
	<9B774728-3508-4850-B036-CB0013403DE9@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	adilger@sun.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33784 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935455Ab0BZIEP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Feb 2010 03:04:15 -0500
Received: from m4.gw.fujitsu.co.jp ([10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o1Q84Cwp013975
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Fri, 26 Feb 2010 17:04:13 +0900
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 92E0645DE6E
	for <linux-ext4@vger.kernel.org>; Fri, 26 Feb 2010 17:04:12 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 523E345DE4D
	for <linux-ext4@vger.kernel.org>; Fri, 26 Feb 2010 17:04:12 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 37785E18003
	for <linux-ext4@vger.kernel.org>; Fri, 26 Feb 2010 17:04:12 +0900 (JST)
Received: from m108.s.css.fujitsu.com (m108.s.css.fujitsu.com [10.249.87.108])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id DB5491DB803F
	for <linux-ext4@vger.kernel.org>; Fri, 26 Feb 2010 17:04:11 +0900 (JST)
In-Reply-To: <9B774728-3508-4850-B036-CB0013403DE9@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Mon, 22 Feb 2010 08:55:53 -0500
Theodore Tso <tytso@MIT.EDU> wrote:
> On Feb 22, 2010, at 12:44 AM, Toshiyuki Okajima wrote:
> >> > > 1) Is the problem psychological?  i.e., is the problem that it is
> >> > > *called* ext4?  After all, ext4 is derived from ext3, so if they are
> >> > > willing to accept new features backported into ext3 (i.e., journal
> >> > > checksums) and the risks associated with making changes to add new
> >> > > features, why are they not willing to accept ext4?
> > > I guess some important basic functions, delayed allocation and quota
> > > seems to be still unstable. At least, if these functions may work
> > > incorrectly, M.C. users cannot use it.
> 
> I haven't seen a bug reported with respect to delayed allocation in quite a 
> while, actually.  That code path is pretty well tested at this point.  
> It's probably one of the more complicated paths, though, which is why if you 
> wanted to be very paranoid, disabling is certainly a valid option.   On the 
> other hand, if you eventually want the performance features of delalloc, 
> there's a question of how much testing do you want to do on interim measures 
> --- but that question applies just as much to ext3 modified to use jbd2 as it ]
> does using ext4 with extents and delayed allocation disabled.
> 
> The main reason why people what to disable delayed allocation is because 
> they have buggy applications which don't use fsync() but which depend on 
> the data being written to disk after a crash.  But that's an application 
> issue, not a file system issue --- and I'll note that even with ext3, if 
> you don't use fsync(), there is a chance you will lose data after a power 
> failure.   It's not a very large chance, granted --- but the premise of this
> discussion is that even a small chance of failure is unacceptable for mission 
> critical systems.   So I would argue that if application data is *reliably* 
> lost after a power failure, this is actually a good thing in terms of 
> exposing and then fixing application bugs.   After all, if there is only a 
> 1% chance of losing data on a buggy, non-fsync()'ing application, that might 
> be OK for desktop users but not for M.C. users --- but trying to find those 
> application bugs when they only result in data loss 1% of the time is very, 
> very difficult.   Better to have a system which is much higher performance, 
> but which requires applications to actually do the right thing and use 
> fsync() when they really care about data hitting the disk --- and then doing 
> exhaustive power fail testing of the entire mission critical software stack, 
> and fixing those application bugs.
> 
> As for quota --- quite seriously --- if you have mission critical users, I'd 
> suggest that they not use quota.  Dimitry has been turning up all sorts of 
> bugs in the quota subsystem, many of which are just as applicable to ext3.  
> The real issue is that quota hasn't received as much testing as other file 
> system features --- in any file system, not just ext4.

First of all, the expression which I had previously written seemed to cause 
misunderstanding, so I correct:
I meant "delayed allocation and quota seems to be still unstable" was
"there is the possibility which some problems happen by using both delayed 
allocation and quota".

If the applications aren't implemented correctly, I understand the "fsync()" 
problem that data can lose after a crash. But there was no deep consideration
for my changing the journaling interface of ext3. I thought that it was easier 
to maintain only jbd2 than both jbd and jbd2. And I thought we could get 
the integrity features of jbd2 into ext3 by changing the journaling interface.
Besides I thought shifting to jbd2 was very easy because the body of 
ext3(without jbd) had been tested enough and jbd2 is the almost same as jbd
(jbd2 was derived from jbd).
So, I have proposed the change of the journaling interface of ext3 because
I thought the possibility to generate the problem was low. 

However, I find that my proposal to change the journaling interface is 
meaningless after I understand the policy which keeps ext3 stable with ext3 
& jbd.

BTW, the strong reason why I don't recommend that my users use ext4 for the 
present is: we cannot roll back to ext3 from ext4(+extent). 

Though the quality of ext4 is improved day by day, I think the quality of 
ext4 doesn't still reach the one of ext3. 
(using both delalloc&quota is still unstable)

So, if all ext4 problems which we recognize now is solved, I will consider
to let my customer use ext4.

> > > Besides, even if we use ext3 and encounter some troubles by ext3/jbd module,
> > > we can avoid these troubles by using ext2 module during repairing
> > > these troubles. (Because ext3 filesystem can mount as ext2 filesystem by ext2
> > > module.)
> > > But even if we use ext4 with "extents" feature and encounter some troubles
> > > by ext4/jbd2 module, we cannot avoid these troubles by ext2/ext3 modules
> > > because ext3 (or ext2) cannot work "extents" feature. Therefore I think
> > > M.C. users demand that the quality of ext4 is the same as ext3 level or
> > > higher.
> 
> Again, your customers don't have to use extents if they care so much about 
> being able to fall back to ext2.   I'm not sure I understand the thinking 
> behind needing to use the ext2 module while repairing problems.  If there are
> file system corruption issues, e2fsck is used to fix the file system 
> consistency issues --- and e2fsck is used to repair ext2, ext3, and ext4 file
> system issues.  Is the concern the hypothetical one of a file system bug 
> which is uncovered which is so terrible that there is a need to completely 
> change the code base to use ext2 while the file system bug in ext4 is 
> repaired?   (That is, the concern being over a bug in the file system code, 
> as opposed to a file system corruption issue?)
> 
> That seems to be a little far-fetched, since what if the bug is in the 
> generic VM layer, or in a block device driver?  Requiring the ability to use
> an alternate code implementation in case of a failure seems like a very 
> stringent requirement that can't be met in general for most kernel 
> subsystems. Why is the file system singled out as needing this requirement?  
> Also, how big are the disk images used for most mission critical systems.  
> Most of the ones I can think of which are this highly mission critical 
> --- and which can't be addressed by using multiple systems with high 
> availability fallback schemes --- tend to be relatively small, embedded 
> devices (i.e., medical devices and avionics systems), with at best a gigabyte
> or so of storage.  In which case, the amount of effort needed to do a dump, 
> reformat , and restore shouldn't be that big.
The problem which I mentioned is not for the media (storage) but for the codepath.
M.C. users tend to continue to work with the original status if possible because 
they dislike that the time of the system down is long. Therefore they don't like
the operation of backup&restore(+mkfs).
------ step to backup&restore(+mkfs)
(1) system down
(2) restart system with single user-mode (=> all services are stopped.)
(3) dump ext4 files of the device which caused the system down into the storage
(4) do mkfs.ext3 with that device
(5) rewrite /etc/fstab
(6) restore from the storage to ext3
(7) restart system
------ 
Therefore at least, they request the workarounds with immediate effect.

> >> > > 3) How much testing do you need to do before it would be considered
> >> > > acceptable for your Mission Critical users?  Or is it a matter of time
> >> > > to allow other users to be the "guinea pigs"?    :-) 
> >> > >
> > > I think I also have to test the ext4 features (delalloc, quota, mballoc
> > > and so on).
> > > It may cost about half a year or a year ...
> 
> So let me ask you this --- how much testing do you think it would take before
> you were confident that ext3+jbd2 combination would be stable?   And do you 
> have a specific test suite in mind?   (And is that something that can be 
> shared so the rest of the community can help with the testing?)  How does 
> that compare with the six month effort that you have estimated?
> 
> I will note that in general it's not the amount of features that determine 
> the amount of testing required (although it could make a huge difference in 
> terms of fixing bugs that are found), but rather the combinatorics in terms 
> of the set of options which you need to test.   So if you need to test 
> extents vs. extents disabled, delalloc vs. non-delalloc, etc., that's what 
> causes the test matrix to become very large.   But in the case of testing for
> mission critical systems, you don't have to test all of the options.  
> In fact, you may be able to get away with only testing one configuration, or 
> maybe only 2-3 combinations, depending on your customers' requirements.  (I 
> doubt, for example, that you did a full exhaustive testing with ext3 and bh 
> vs nobh, and so on.)
I'm sorry. The period which I previously indicated is my feeling. I do not 
have theoretical grounds for it. 

I think the quality verification of the combination of both ext3 and jbd2 is 
dependent on the quality of implementing the journaling interface of ext3.
So, I thought it was all right if I could increase the quality of the 
journaling interface. And I thought I could improve much more easily the 
quality of ext3+jbd2 than the one of ext4+jbd2.

However, I will find another methods for more improving the integrities of
ext4 so that I can recommend using ext4 earlier to my customers because I 
understand new features should not be added to ext3.

Thanks,
Toshiyuki Okajima
