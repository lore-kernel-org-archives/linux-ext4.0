From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] e2fsprogs: Support for large inode migration.
Date: Thu, 26 Jul 2007 17:15:30 +0530
Message-ID: <46A8895A.5000308@linux.vnet.ibm.com>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <3ae4c55b831a13f9fbb9a187efcd65d29434bf09.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <20070725143209.GA23613@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:45924 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbXGZLqF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Jul 2007 07:46:05 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l6QC9AqK206944
	for <linux-ext4@vger.kernel.org>; Thu, 26 Jul 2007 22:09:10 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6QBnC9g139378
	for <linux-ext4@vger.kernel.org>; Thu, 26 Jul 2007 21:49:12 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6QBjdhW024329
	for <linux-ext4@vger.kernel.org>; Thu, 26 Jul 2007 21:45:39 +1000
In-Reply-To: <20070725143209.GA23613@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Theodore Tso wrote:
> On Wed, Jul 25, 2007 at 11:06:28AM +0530, Aneesh Kumar K.V wrote:
>> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>>
>> Add new option -I <inode_size> to tune2fs.
>> This is used to change the inode size. The size
>> need to be multiple of 2 and we don't allow to
>> decrease the inode size.
>>
>> As a part of increasing the inode size we throw
>> away the free inodes in the last block group. If
>> we can't we fail. In such case one can resize the
>> file system and then try to increase the inode size.
> 
> Let me guess, you're testing with a filesystem with two block groups,
> right?  And to date you've tested *only* by doubling the size of the
> inode.
> 


I tested this with multiple ( 1 and 7 ) groups. But yes all the testing was to change
inode size from 128 to 256. 


> What your patch does is is keep the number of inode blocks per block
> group constant, so that the total number of inodes decreases by
> whatever factor the inode size is increasing.  It's a cheap, dirty way
> of doing the resizing, since it avoids needing to either (a) update
> directory entries when inode numbers get renumbered, and (b) need to
> update inodes when blocks need to get relocated in order to make room
> for growing the inode table.
> 


That is correct. What i was looking at was to get the dynamic inode location
first. That should help us to place large inode any where right ?. But i know
that is a long term goal since there is no patches for dynamic inode location.

I will work at increasing the inode table size as a part of increasing the inode
size. 



> The problem with your patch is:
> 
> 	* By shrinking the number of inodes, it can constrain the
>           ability of the filesystem to create new files in the future.
> 

I explained this in the commit log.


> 	* It ruins the inode and block placement algorithms where we
>           try to keep inodes in the same block group as their parent
>           directory, and we try to allocate blocks in the same block
>           group as their containing inode.


I missed this in my analysis. So this means we may end up with bad performance
after resizing the inode. I will look at increasing the inode table size as a
part of increasing the inode size.


> 
> 	* Because when the current patch makes no attempt to relocate
>           inodes, and when it doubles the inode size, it chops the
>           number of inodes in half, there must be no inodes in the
>           last half of the inode table.  That is if there are N block
>           groups, the inode tables in blockgroups N/2 to N-1 must be
>           empty.  But because of the block group spreading algorithm,
>           where new directories get pushed out to new block groups, in
>           any real real-life filesystem, the use of block groups is
>           evenly spread out, which means in practice you won't see
>           case where the last half of the inodes will not be in use.
>           Hence, your patch won't actually work in practice.
> 
> So unfortunately, the right answer *will* require expanding the inode
> tables, and potentially moving blocks out of the way in order to make
> room for it.  A lot of that machinery is in resize2fs, actually, and
> I'm wondering if the right answer is to move resize2fs's functionality
> into tune2fs.  We will also need this to be able to add the resize
> inode after the fact.
> 
> That's not going to be a trivial set of changes; if you're looking for
> something to test the undo manager, my suggestion would be to wire it
> up into mke2fs and/or e2fsck first.  Mke2fs might be nice since it
> will give us a recovery path in case someone screws up the arguments
> to mkfs.  
> 

I guess Undo I/O manager can go in because I have been using it for
the ext3 -> ext4 inode migration testing and for testing the above patch.


Why would one need to recover on mkfs. He can very well run mkfs again right ?



>> tune2fs use undo I/O manager when migrating to large
>> inode. This helps in reverting the changes if end results
>> are not correct.The environment variable TUNE2FS_SCRATCH_DIR
>> is used to indicate the  directory within which the tdb
>> file need to be created. The file will be named tune2fs-XXXXXX
> 
> My suggestion would be to use something like /var/lib/e2fsprogs as the
> defalut directory.  And we should also do some tests to make sure
> something sane happens if we run out of room for the undo file.
> Presumably the only thing we can do is to abort the run and then back
> out the chnages using what was written out to the undo file.
> 

I had a FIXME!! in the code which stated it would be nice to use the  conf file
But right now the conffile is e2fsck specific

+	char *tdb_dir, tdb_file[PATH_MAX];
+#if 0 /* FIXME!! */
+	/*
+	 * Configuration via a conf file would be
+	 * nice
+	 */
+	profile_get_string(profile, "scratch_files",
+					"directory", 0, 0,
+					&tdb_dir);
+#endif
+	tdb_dir = getenv("TUNE2FS_SCRATCH_DIR");


-aneesh
