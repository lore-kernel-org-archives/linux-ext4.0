From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [RFC] do you want jbd2 interface of ext3?
Date: Mon, 22 Feb 2010 08:55:53 -0500
Message-ID: <9B774728-3508-4850-B036-CB0013403DE9@mit.edu>
References: <20100216164123.b10b00e5.toshi.okajima@jp.fujitsu.com> <20100216185452.GE3153@quack.suse.cz> <4B7BAA70.9070605@jp.fujitsu.com> <20100217164933.GC5337@thunk.org> <4B8219B8.8070207@jp.fujitsu.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	adilger@sun.com, linux-ext4@vger.kernel.org
To: toshi.okajima@jp.fujitsu.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:53266 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277Ab0BVN4B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Feb 2010 08:56:01 -0500
In-Reply-To: <4B8219B8.8070207@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Feb 22, 2010, at 12:44 AM, Toshiyuki Okajima wrote:
> > 1) Is the problem psychological?  i.e., is the problem that it is
> > *called* ext4?  After all, ext4 is derived from ext3, so if they are
> > willing to accept new features backported into ext3 (i.e., journal
> > checksums) and the risks associated with making changes to add new
> > features, why are they not willing to accept ext4?
> I guess some important basic functions, delayed allocation and quota
> seems to be still unstable. At least, if these functions may work
> incorrectly, M.C. users cannot use it.

I haven't seen a bug reported with respect to delayed allocation in quite a while, actually.  That code path is pretty well tested at this point.  It's probably one of the more complicated paths, though, which is why if you wanted to be very paranoid, disabling is certainly a valid option.   On the other hand, if you eventually want the performance features of delalloc, there's a question of how much testing do you want to do on interim measures --- but that question applies just as much to ext3 modified to use jbd2 as it does using ext4 with extents and delayed allocation disabled.

The main reason why people what to disable delayed allocation is because they have buggy applications which don't use fsync() but which depend on the data being written to disk after a crash.  But that's an application issue, not a file system issue --- and I'll note that even with ext3, if you don't use fsync(), there is a chance you will lose data after a power failure.   It's not a very large chance, granted --- but the premise of this discussion is that even a small chance of failure is unacceptable for mission critical systems.   So I would argue that if application data is *reliably* lost after a power failure, this is actually a good thing in terms of exposing and then fixing application bugs.   After all, if there is only a 1% chance of losing data on a buggy, non-fsync()'ing appli
 cation, that might be OK for desktop users but not for M.C. users --- but trying to find those application bugs when they only result in data loss 1% of the time is very, very difficult.   Better to have a system which is much higher performance, but which requires applications to actually do the right thing and use fsync() when they really care about data hitting the disk --- and then doing exhaustive power fail testing of the entire mission critical software stack, and fixing those application bugs.

As for quota --- quite seriously --- if you have mission critical users, I'd suggest that they not use quota.  Dimitry has been turning up all sorts of bugs in the quota subsystem, many of which are just as applicable to ext3.  The real issue is that quota hasn't received as much testing as other file system features --- in any file system, not just ext4.

> Besides, even if we use ext3 and encounter some troubles by ext3/jbd module,
> we can avoid these troubles by using ext2 module during repairing
> these troubles. (Because ext3 filesystem can mount as ext2 filesystem by ext2
> module.)
> But even if we use ext4 with "extents" feature and encounter some troubles
> by ext4/jbd2 module, we cannot avoid these troubles by ext2/ext3 modules
> because ext3 (or ext2) cannot work "extents" feature. Therefore I think
> M.C. users demand that the quality of ext4 is the same as ext3 level or
> higher.

Again, your customers don't have to use extents if they care so much about being able to fall back to ext2.   I'm not sure I understand the thinking behind needing to use the ext2 module while repairing problems.  If there are file system corruption issues, e2fsck is used to fix the file system consistency issues --- and e2fsck is used to repair ext2, ext3, and ext4 file system issues.  Is the concern the hypothetical one of a file system bug which is uncovered which is so terrible that there is a need to completely change the code base to use ext2 while the file system bug in ext4 is repaired?   (That is, the concern being over a bug in the file system code, as opposed to a file system corruption issue?)

That seems to be a little far-fetched, since what if the bug is in the generic VM layer, or in a block device driver?  Requiring the ability to use an alternate code implementation in case of a failure seems like a very stringent requirement that can't be met in general for most kernel subsystems.  Why is the file system singled out as needing this requirement?  Also, how big are the disk images used for most mission critical systems.  Most of the ones I can think of which are this highly mission critical --- and which can't be addressed by using multiple systems with high availability fallback schemes --- tend to be relatively small, embedded devices (i.e., medical devices and avionics systems), with at best a gigabyte or so of storage.  In which case, the amount of effort needed to do a 
 dump, reformat , and restore shouldn't be that big.


> > 3) How much testing do you need to do before it would be considered
> > acceptable for your Mission Critical users?  Or is it a matter of time
> > to allow other users to be the "guinea pigs"?   :-)
> >
> I think I also have to test the ext4 features (delalloc, quota, mballoc
> and so on).
> It may cost about half a year or a year ...

So let me ask you this --- how much testing do you think it would take before you were confident that ext3+jbd2 combination would be stable?   And do you have a specific test suite in mind?   (And is that something that can be shared so the rest of the community can help with the testing?)  How does that compare with the six month effort that you have estimated?

I will note that in general it's not the amount of features that determine the amount of testing required (although it could make a huge difference in terms of  fixing bugs that are found), but rather the combinatorics in terms of the set of options which you need to test.   So if you need to test extents vs. extents disabled, delalloc vs. non-delalloc, etc., that's what causes the test matrix to become very large.   But in the case of testing for mission critical systems, you don't have to test all of the options.  In fact, you may be able to get away with only testing one configuration, or maybe only 2-3 combinations, depending on your customers' requirements.  (I doubt, for example, that you did a full exhaustive testing with ext3 and bh vs nobh, and so on.)

Best regards,

-- Ted

