From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: delayed extent tree test cases
Date: Tue, 13 Mar 2012 23:34:52 -0700
Message-ID: <4F603C0C.9080406@linux.vnet.ibm.com>
References: <4F5992B6.7070105@linux.vnet.ibm.com> <CAGBYx2Y8mJJ05=XcTYUVK07deS2GFUCrTVJoZy9Jaj7958OsEA@mail.gmail.com> <4F59A599.4050400@linux.vnet.ibm.com> <CAGBYx2binmZZnOsEva0e_vxWhzFSv6gVnU35yRVyWTSXGXKp=A@mail.gmail.com> <4F5A3277.40506@linux.vnet.ibm.com> <CAGBYx2aQKPWCu5tNzDxQM5Jy5bO-hgvE7Vsnd3kCYzr=MeOJFQ@mail.gmail.com> <4F5E8F15.9090602@linux.vnet.ibm.com> <CAGBYx2aTGUERCXGEo5NrwPpv=URaVp3uB8qwwExepCmZ6ue5Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>,
	"Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@linux.vnet.ibm.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34437 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030695Ab2CNGfR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Mar 2012 02:35:17 -0400
Received: from /spool/local
	by e1.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Wed, 14 Mar 2012 02:35:16 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id A55F838C8052
	for <linux-ext4@vger.kernel.org>; Wed, 14 Mar 2012 02:34:55 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2E6Yt22046826
	for <linux-ext4@vger.kernel.org>; Wed, 14 Mar 2012 02:34:55 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2E6YsOb019287
	for <linux-ext4@vger.kernel.org>; Wed, 14 Mar 2012 03:34:55 -0300
In-Reply-To: <CAGBYx2aTGUERCXGEo5NrwPpv=URaVp3uB8qwwExepCmZ6ue5Mw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/12/2012 08:39 PM, Yongqiang Yang wrote:
>>
>> Well, it was my impression that the purpose of extent locks it to replace
>> i_mutex.  Maybe I dont quite understand what you mean by user space?
> Sorry, I understood that wrongly.  Thank you for your explanation and
> I think I am clear now:-)
>
>
> Let's get back to concerns, there are two concerns:sync and dead lock.
>
> I don't think we need to sync two trees, actually IMHO it is
> impossible to sync the two trees.  Consider that write acquire lock on
> extent which exceeds the tail of a file before doing actual writing,
> that says, we need to lock an extent before it appears in extent tree
> on disk.

Oh, yes this condition I handle in the extent lock logic that we havent 
discussed much yet.  Basically the new extent lock logic adds a "status" 
member to the extent structure that can be either "delayed" "allocated" 
or "hole".  The idea is if we try to lock something in the tree that is 
not there yet, it gets allocated as a "hole" extent.  And on unlocking, 
destroy only if its a hole, and nobody else is waiting to lock it. I'll 
also need to put in some special splitting logic for when a "hole" 
becomes becomes "delayed" or "allocated" sense we need retain the 
information about whose got it locked.

I guess now that we've reasoned away the need to track the allocated 
extents exactly, maybe we really dont need "allocated" and "hole". Maybe 
all we really need is just "delayed" and "not delayed", or something 
like that.  Though if some one later decides to expand the tree's 
functionality, it might help to put in that infrastructure now.

At the time I had suggested tracking the allocated extents, people saw 
other uses for it too.  It would pretty much speed up any operation that 
needs to go walk the on disk extent tree just to see what its state is. 
  Like extent searching, allocating new space, etc.  As useful as these 
things are though, maybe we should just try to tackle one new feature at 
a time. :)

>
> Below is the 2nd concern quoted from your email:
> ======================================================
>   For example, say process A locks a logical range of blocks, 1-5 and
> process B locks a logical range of blocks 6-10.  But if the on disk
> extents are actually 1-2, 3-7 and 8-10, we have a situation where both
> processes own a piece of the 3-7 extent, but they wont know it until
> they get down into the on disk extents. And it seems to me they should
> really have the whole on disk extent locked before they do any on disk
> splitting.  And now we have a deadlock condition since one of them is
> going to have to give up their lock before the other can proceed.  So
> that's when I started thinking maybe we need to make sure that the
> locked ranges are extent aligned.  Does that make sense?
> ======================================================
>
> I don't think we should hold extent lock just before we modify extent
> tree on disk .  All operations that will modify extent tree on disk
> have hold extent lock before they acquire i_data_sem, so it is safe
> for them to split extent or do something else, because they have hold
> the extent lock they should hold.
>
> Continue with your example, both processes own a piece of 3-7 extent,
> so they have hold their extent lock before acquiring i_data_sem, if
> process A splits the extent, for example, it removes extent it locked
> from on disk tree.  The piece of 3-7 extent which process A does not
> lock is still there.  Both processed works with no problem.

Right, these points make sense. i_data_sem will save us here from having 
to mirror the extents exactly.  I guess with the current scheme I have, 
if an operation removes an extent (allocated or delayed), it would just 
turn into a "hole" extent (or maybe the "not delayed" type).  Im glad 
you point it out though, because it hadn't crossed my mind earlier.  We 
will need to be careful to only change the status of any locked extent 
being removed so that we dont free our own lock :)

Allison Henderson

>
> Yongqiang.
>>>
>>> So maybe we just need to wait lock freed before truncate and puch
>>> hole.  Are there any other operations changing data of a file?
>>
>>
>> So, definitely punch hole and truncate will need to be locking the space
>> they are removing, but there are a lot of other places where i_mutex will
>> need to be replaced too.  I had a list a while ago of all the i_mutex
>> occurrences in ext4.  I can repost here so we can talk about though.
>>   Replacing all these will probably be the last part of the extent lock
>> project, after i get the tree tracking allocated extents, and then the
>> locking logic on top of that.
>>
>> Ext4 functions that lock i_mutex:
>> ext4_sync_file
>> ext4_fallocate
>> ext4_move_extents via two helper routines:
>>     mext_inode_double_lock and mext_inode_double_unlock
>> ext4_ioctl (for the EXT4_IOC_SETFLAGS ioctl)
>> ext4_quota_write
>> ext4_llseek
>> ext4_end_io_work
>> ext4_ind_direct_IO (only while calling ext4_flush_completed_IO)
>>
>> Functions called by vfs with i_mutex locked:
>> ext4_setattr
>> ext4_da_writepages
>> ext4_rmdir
>> ext4_unlink
>> ext4_symlink
>> ext4_link
>> ext4_rename
>> ext4_get_block
>>
>> For these functions called by the vfs, I dont plan to go change vfs code,
>> but we will need to be locking them ourselves in the ext4 code if we want
>> them to by synchronous with the functions in the first list as they are
>> today.  Let me know if you see any thing missing or incorrect though.
>>
>>
>>
>>>
>>>
>>>   Maybe
>>>>
>>>> there is something I am overlooking that would help simplify.
>>>
>>> Ok.  Now we have two extent trees - the first one is used to implement
>>> extent locking while the second one is used to map logical blocks to
>>> physical blocks.  If we protect operations on the two trees by
>>> i_data_sem, then two trees are synced.  For example, given that a
>>> process wants to modify a tree, it has to acquire i_data_sem, then no
>>> other processes can access any tree.
>>>
>>>
>>> Maybe I am overlooking something.:-)
>>>
>>> Yongqiang.
>>
>>
>> Ok, got it :) I probably should have seen i_data_sem would solve this. Thank
>> you for pointing it out though, it does simplify things a lot. Thx for all
>> the advice :)
>>
>> Allison Henderson
>>
>>
>>>>
>>>> Allison Henderson
>>>>
>>>>>
>>>>>>
>>>>>> Thx!
>>>>>> Allison Henderson
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>
>>>
>>>
>>>
>>
>
>
>

