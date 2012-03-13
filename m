From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: delayed extent tree test cases
Date: Mon, 12 Mar 2012 17:04:37 -0700
Message-ID: <4F5E8F15.9090602@linux.vnet.ibm.com>
References: <4F5992B6.7070105@linux.vnet.ibm.com> <CAGBYx2Y8mJJ05=XcTYUVK07deS2GFUCrTVJoZy9Jaj7958OsEA@mail.gmail.com> <4F59A599.4050400@linux.vnet.ibm.com> <CAGBYx2binmZZnOsEva0e_vxWhzFSv6gVnU35yRVyWTSXGXKp=A@mail.gmail.com> <4F5A3277.40506@linux.vnet.ibm.com> <CAGBYx2aQKPWCu5tNzDxQM5Jy5bO-hgvE7Vsnd3kCYzr=MeOJFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>,
	"Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@linux.vnet.ibm.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60082 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab2CMAFa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Mar 2012 20:05:30 -0400
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Mon, 12 Mar 2012 20:05:29 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id DB8F738C805A
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 20:04:40 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2D04ejo203814
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 20:04:40 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2D5ZWc9012046
	for <linux-ext4@vger.kernel.org>; Tue, 13 Mar 2012 01:35:33 -0400
In-Reply-To: <CAGBYx2aQKPWCu5tNzDxQM5Jy5bO-hgvE7Vsnd3kCYzr=MeOJFQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/11/2012 07:12 AM, Yongqiang Yang wrote:
>>>> get it to mirror the existing extents.  That way we will know what
>>>> extents
>>>> there are to lock before we start doing things with the current extent
>>>> tree.
>>>>
>>>> When I think about all the ins and outs of trying to keep the trees in
>>>> sync,
>>>
>>> Actually, delayed extents is also synced.  This can be easily achieved
>>> by protecting operations on extent tree by i_data_sem.
>>
>> Ah, sorry I could have phrased that better.  What I meant was trying to keep
>> the new status tree in sync with the on disk tree so that the status tree
>> mirrors the same allocated extents in the on disk tree.
>>
>>>
>>> I am a little confused by partial extent here.  I am guessing you
>>> meant extent rb-tree in memory is the mirror of extent tree in inode
>>> which is stored on disk.  Am I right?
>>>
>>> In my head, the extent tree used by extent lock traces logical
>>> extents, for example, a process locks a range of a file and it does
>>> not care the physical blocks.    So we just need to record logical
>>> extent without physical blocks infos.  Then locking on an extent may
>>> trigger splitting on an extent while unlocking may trigger merging on
>>> extents.  Am I right?
>>>
>>> Yongqiang.
>>>
>>
>> Well initially I was doing something similar to that, where we only lock
>> logical ranges that may or may not be "extent aligned" with the on disk
>> extents.  But the concern that I have though is that we may end up with
>> processes that have the same on disk extent locked.  For example, say
>> process A locks a logical range of blocks, 1-5 and process B locks a logical
>> range of blocks 6-10.  But if the on disk extents are actually 1-2, 3-7 and
>> 8-10, we have a situation where both processes own a piece of the 3-7
>> extent, but they wont know it until they get down into the on disk extents.
>>   And it seems to me they should really have the whole on disk extent locked
>> before they do any on disk splitting.  And now we have a deadlock condition
>> since one of them is going to have to give up their lock before the other
>> can proceed.  So that's when I started thinking maybe we need to make sure
>> that the locked ranges are extent aligned.  Does that make sense?
> Extent lock is provided to user space process not to kernel, right?
> An process acquires extent lock, so that other processes can not
> access the locked extent.  In other words, extent lock is used to
> protect data in file, not internal data structure of filesystem.  What
> we need to guarantee is that data in the locked extent is not changed,
> while extent tree on disk can be changed.

Well, it was my impression that the purpose of extent locks it to 
replace i_mutex.  Maybe I dont quite understand what you mean by user 
space?  But I think I understand what you are saying about i_data_sem 
protecting the internal structures, and extent locks protecting the 
read/write of data. :) i_data_sem should protect us from the concern I 
pointed out earlier, so that will certainly simplify things.

>
> So maybe we just need to wait lock freed before truncate and puch
> hole.  Are there any other operations changing data of a file?

So, definitely punch hole and truncate will need to be locking the space 
they are removing, but there are a lot of other places where i_mutex 
will need to be replaced too.  I had a list a while ago of all the 
i_mutex occurrences in ext4.  I can repost here so we can talk about 
though.  Replacing all these will probably be the last part of the 
extent lock project, after i get the tree tracking allocated extents, 
and then the locking logic on top of that.

Ext4 functions that lock i_mutex:
ext4_sync_file
ext4_fallocate
ext4_move_extents via two helper routines:
     mext_inode_double_lock and mext_inode_double_unlock
ext4_ioctl (for the EXT4_IOC_SETFLAGS ioctl)
ext4_quota_write
ext4_llseek
ext4_end_io_work
ext4_ind_direct_IO (only while calling ext4_flush_completed_IO)

Functions called by vfs with i_mutex locked:
ext4_setattr
ext4_da_writepages
ext4_rmdir
ext4_unlink
ext4_symlink
ext4_link
ext4_rename
ext4_get_block

For these functions called by the vfs, I dont plan to go change vfs 
code, but we will need to be locking them ourselves in the ext4 code if 
we want them to by synchronous with the functions in the first list as 
they are today.  Let me know if you see any thing missing or incorrect 
though.


>
>
>   Maybe
>> there is something I am overlooking that would help simplify.
> Ok.  Now we have two extent trees - the first one is used to implement
> extent locking while the second one is used to map logical blocks to
> physical blocks.  If we protect operations on the two trees by
> i_data_sem, then two trees are synced.  For example, given that a
> process wants to modify a tree, it has to acquire i_data_sem, then no
> other processes can access any tree.
>
>
> Maybe I am overlooking something.:-)
>
> Yongqiang.

Ok, got it :) I probably should have seen i_data_sem would solve this. 
Thank you for pointing it out though, it does simplify things a lot. 
Thx for all the advice :)

Allison Henderson

>>
>> Allison Henderson
>>
>>>
>>>>
>>>> Thx!
>>>> Allison Henderson
>>>>
>>>
>>>
>>>
>>
>
>
>

