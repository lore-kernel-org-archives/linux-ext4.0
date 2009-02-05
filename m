From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] ext4_bmap() may return blocks outside filesystem
Date: Thu, 5 Feb 2009 11:48:03 -0500
Message-ID: <20090205164803.GM8945@mit.edu>
References: <498AD58B.5000805@ph.tum.de> <20090205134905.GL8945@mit.edu> <87f94c370902050722wf2099c9i2d815737e85209f3@mail.gmail.com> <498B084F.2060608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Thiemo Nagel <thiemo.nagel@ph.tum.de>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33287 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZBEQsL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 11:48:11 -0500
Content-Disposition: inline
In-Reply-To: <498B084F.2060608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 05, 2009 at 10:39:59AM -0500, Ric Wheeler wrote:
> Greg Freemyer wrote:
>> This is just a rant, and I doubt anyone can do anything about it, but
>> it is still worth reading imho.

It also has absolutely nothing to do with the original thread, which
was block numbers which are far outside the range of valid block
numbers given the size of the block device.  :-)

>> My big concern is that neither is proposing a way for a tool like fsck
>> to query the storage device to verify the filesystem's view of what is
>> mapped vs unmapped agrees with the storage devices view.
>>   
> I think that from a file system point of view (including tools like  
> fsck), that is a feature, not a bug. The features should be, if done  
> right, invisible to us and this should be irrelevant to fsck .....

Yeah, pretty much.  There are two cases.  One is where the
thin-provisioned disk thinks the block is in use, but it is marked as
not in use.  That is only a problem in that some space is wasted.  It
could occur the first time the filesystem is moved onto the
thin-provisioned device.  Adding code to e2fsck to support this is not
particularly hard.  It's just somethining you would do after fsck's
pass 5, once the block allocation bitmaps are validated.  Or you could
do it as a separate program, which requires that the last fsck time ==
the mount time, and then uses the block allocation bitmaps to tell the
storage device that which blocks aren't in use.

The other case is where the block is still in use by the filesystem,
but somehow the thin-provisioned disk thinks it is freed.  This is
most likely going to happen if a block is claimed as being in use by
two inodes, and then one of the two inodes is deleted.  This case has
almost always involved data loss, since the original inode's data was
already overwritten, and even if it was the original inode which gets
deleted, since the block is marked freed, the filesystem can allocate
it for use by a new inode, and then the other inode's data would get
corrupted.

>> Lacking any knowledge of which specific sectors the underlying storage
>> systems treats as reliable vs. unreliable, I can imagine the
>> filesystem corruption will go from a correctable situation to a
>> "restore from backups" situation.

As I have described in above, if the block allocation bitmaps are
corrupted to the point where this problem can occur, the possibility
for data loss has already happened; this is nothing new.  The only
thing new here is that instead of the data getting corrupted when the
block gets reused by another inode in the same filesystem, it can get
corrupted when the block gets reused by data in another filesystem.
(And, the data might get immediately invalidated as soon as the TRIM
command or equivalent is sent to the storage device.  That just makes
the data loss deterministic.)

So this is not a new secnario, and fortunately, it rarely happens,
thanks to ext3's journalling.  The most common way it happened before
was with ext2 filesystems when impatient users bypassed fsck after an
unclean shutdown.  These days, it usually requires some kind of
hardware failure, either in memory or in the storage subsystem.

> I disagree - any written data, specifically all meta-data, will have the  
> correct data returned on read. All unmapped data is also by definition  
> un-allocated at the fs layer (for fsck as well) and we should not be  
> reading it back if the tools work correctly.

... or if there is a hardware problem, but this is a previously
unsolved problem.  And things work fairly well today.

>> The solution in my mind is that both specs add a way for diagnostic
>> tools to query the status of a sector to see if it is mapped vs
>> unmapped, etc.

This is not a bad thing, and if it's there, utilities to make sure the
storage device is in synch with the block allocation devices isn't a
bad thing, but I suspect the main reason will be for efficiency's
sake; currently on an unclean shutdown, we don't report the blocks
that were freed immediately before an unclean shutdown, since that's
just a storage leak, not a data loss problem.  And if the blocks gets
reused immediately afterwards, it's not a big deal at all.

       		   	       	    	  - Ted
