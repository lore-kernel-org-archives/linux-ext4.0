From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: delayed extent tree test cases
Date: Tue, 13 Mar 2012 11:39:04 +0800
Message-ID: <CAGBYx2aTGUERCXGEo5NrwPpv=URaVp3uB8qwwExepCmZ6ue5Mw@mail.gmail.com>
References: <4F5992B6.7070105@linux.vnet.ibm.com>
	<CAGBYx2Y8mJJ05=XcTYUVK07deS2GFUCrTVJoZy9Jaj7958OsEA@mail.gmail.com>
	<4F59A599.4050400@linux.vnet.ibm.com>
	<CAGBYx2binmZZnOsEva0e_vxWhzFSv6gVnU35yRVyWTSXGXKp=A@mail.gmail.com>
	<4F5A3277.40506@linux.vnet.ibm.com>
	<CAGBYx2aQKPWCu5tNzDxQM5Jy5bO-hgvE7Vsnd3kCYzr=MeOJFQ@mail.gmail.com>
	<4F5E8F15.9090602@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>,
	"Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@linux.vnet.ibm.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42441 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab2CMDjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Mar 2012 23:39:06 -0400
Received: by gghe5 with SMTP id e5so107063ggh.19
        for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 20:39:04 -0700 (PDT)
In-Reply-To: <4F5E8F15.9090602@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>
> Well, it was my impression that the purpose of extent locks it to rep=
lace
> i_mutex. =A0Maybe I dont quite understand what you mean by user space=
?
Sorry, I understood that wrongly.  Thank you for your explanation and
I think I am clear now:-)


Let's get back to concerns, there are two concerns:sync and dead lock.

I don't think we need to sync two trees, actually IMHO it is
impossible to sync the two trees.  Consider that write acquire lock on
extent which exceeds the tail of a file before doing actual writing,
that says, we need to lock an extent before it appears in extent tree
on disk.

Below is the 2nd concern quoted from your email:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 For example, say process A locks a logical range of blocks, 1-5 and
process B locks a logical range of blocks 6-10.  But if the on disk
extents are actually 1-2, 3-7 and 8-10, we have a situation where both
processes own a piece of the 3-7 extent, but they wont know it until
they get down into the on disk extents. And it seems to me they should
really have the whole on disk extent locked before they do any on disk
splitting.  And now we have a deadlock condition since one of them is
going to have to give up their lock before the other can proceed.  So
that's when I started thinking maybe we need to make sure that the
locked ranges are extent aligned.  Does that make sense?
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

I don't think we should hold extent lock just before we modify extent
tree on disk .  All operations that will modify extent tree on disk
have hold extent lock before they acquire i_data_sem, so it is safe
for them to split extent or do something else, because they have hold
the extent lock they should hold.

Continue with your example, both processes own a piece of 3-7 extent,
so they have hold their extent lock before acquiring i_data_sem, if
process A splits the extent, for example, it removes extent it locked
from on disk tree.  The piece of 3-7 extent which process A does not
lock is still there.  Both processed works with no problem.

Yongqiang.
>>
>> So maybe we just need to wait lock freed before truncate and puch
>> hole. =A0Are there any other operations changing data of a file?
>
>
> So, definitely punch hole and truncate will need to be locking the sp=
ace
> they are removing, but there are a lot of other places where i_mutex =
will
> need to be replaced too. =A0I had a list a while ago of all the i_mut=
ex
> occurrences in ext4. =A0I can repost here so we can talk about though=
=2E
> =A0Replacing all these will probably be the last part of the extent l=
ock
> project, after i get the tree tracking allocated extents, and then th=
e
> locking logic on top of that.
>
> Ext4 functions that lock i_mutex:
> ext4_sync_file
> ext4_fallocate
> ext4_move_extents via two helper routines:
> =A0 =A0mext_inode_double_lock and mext_inode_double_unlock
> ext4_ioctl (for the EXT4_IOC_SETFLAGS ioctl)
> ext4_quota_write
> ext4_llseek
> ext4_end_io_work
> ext4_ind_direct_IO (only while calling ext4_flush_completed_IO)
>
> Functions called by vfs with i_mutex locked:
> ext4_setattr
> ext4_da_writepages
> ext4_rmdir
> ext4_unlink
> ext4_symlink
> ext4_link
> ext4_rename
> ext4_get_block
>
> For these functions called by the vfs, I dont plan to go change vfs c=
ode,
> but we will need to be locking them ourselves in the ext4 code if we =
want
> them to by synchronous with the functions in the first list as they a=
re
> today. =A0Let me know if you see any thing missing or incorrect thoug=
h.
>
>
>
>>
>>
>> =A0Maybe
>>>
>>> there is something I am overlooking that would help simplify.
>>
>> Ok. =A0Now we have two extent trees - the first one is used to imple=
ment
>> extent locking while the second one is used to map logical blocks to
>> physical blocks. =A0If we protect operations on the two trees by
>> i_data_sem, then two trees are synced. =A0For example, given that a
>> process wants to modify a tree, it has to acquire i_data_sem, then n=
o
>> other processes can access any tree.
>>
>>
>> Maybe I am overlooking something.:-)
>>
>> Yongqiang.
>
>
> Ok, got it :) I probably should have seen i_data_sem would solve this=
=2E Thank
> you for pointing it out though, it does simplify things a lot. Thx fo=
r all
> the advice :)
>
> Allison Henderson
>
>
>>>
>>> Allison Henderson
>>>
>>>>
>>>>>
>>>>> Thx!
>>>>> Allison Henderson
>>>>>
>>>>
>>>>
>>>>
>>>
>>
>>
>>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
