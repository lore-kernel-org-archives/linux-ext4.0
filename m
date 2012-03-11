From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: delayed extent tree test cases
Date: Sun, 11 Mar 2012 22:12:08 +0800
Message-ID: <CAGBYx2aQKPWCu5tNzDxQM5Jy5bO-hgvE7Vsnd3kCYzr=MeOJFQ@mail.gmail.com>
References: <4F5992B6.7070105@linux.vnet.ibm.com>
	<CAGBYx2Y8mJJ05=XcTYUVK07deS2GFUCrTVJoZy9Jaj7958OsEA@mail.gmail.com>
	<4F59A599.4050400@linux.vnet.ibm.com>
	<CAGBYx2binmZZnOsEva0e_vxWhzFSv6gVnU35yRVyWTSXGXKp=A@mail.gmail.com>
	<4F5A3277.40506@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>,
	"Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@linux.vnet.ibm.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47412 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab2CKOMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Mar 2012 10:12:09 -0400
Received: by iagz16 with SMTP id z16so5367506iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 11 Mar 2012 07:12:08 -0700 (PDT)
In-Reply-To: <4F5A3277.40506@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>> get it to mirror the existing extents. =A0That way we will know wha=
t
>>> extents
>>> there are to lock before we start doing things with the current ext=
ent
>>> tree.
>>>
>>> When I think about all the ins and outs of trying to keep the trees=
 in
>>> sync,
>>
>> Actually, delayed extents is also synced. =A0This can be easily achi=
eved
>> by protecting operations on extent tree by i_data_sem.
>
> Ah, sorry I could have phrased that better. =A0What I meant was tryin=
g to keep
> the new status tree in sync with the on disk tree so that the status =
tree
> mirrors the same allocated extents in the on disk tree.
>
>>
>> I am a little confused by partial extent here. =A0I am guessing you
>> meant extent rb-tree in memory is the mirror of extent tree in inode
>> which is stored on disk. =A0Am I right?
>>
>> In my head, the extent tree used by extent lock traces logical
>> extents, for example, a process locks a range of a file and it does
>> not care the physical blocks. =A0 =A0So we just need to record logic=
al
>> extent without physical blocks infos. =A0Then locking on an extent m=
ay
>> trigger splitting on an extent while unlocking may trigger merging o=
n
>> extents. =A0Am I right?
>>
>> Yongqiang.
>>
>
> Well initially I was doing something similar to that, where we only l=
ock
> logical ranges that may or may not be "extent aligned" with the on di=
sk
> extents. =A0But the concern that I have though is that we may end up =
with
> processes that have the same on disk extent locked. =A0For example, s=
ay
> process A locks a logical range of blocks, 1-5 and process B locks a =
logical
> range of blocks 6-10. =A0But if the on disk extents are actually 1-2,=
 3-7 and
> 8-10, we have a situation where both processes own a piece of the 3-7
> extent, but they wont know it until they get down into the on disk ex=
tents.
> =A0And it seems to me they should really have the whole on disk exten=
t locked
> before they do any on disk splitting. =A0And now we have a deadlock c=
ondition
> since one of them is going to have to give up their lock before the o=
ther
> can proceed. =A0So that's when I started thinking maybe we need to ma=
ke sure
> that the locked ranges are extent aligned. =A0Does that make sense?
Extent lock is provided to user space process not to kernel, right?
An process acquires extent lock, so that other processes can not
access the locked extent.  In other words, extent lock is used to
protect data in file, not internal data structure of filesystem.  What
we need to guarantee is that data in the locked extent is not changed,
while extent tree on disk can be changed.

So maybe we just need to wait lock freed before truncate and puch
hole.  Are there any other operations changing data of a file?


=A0Maybe
> there is something I am overlooking that would help simplify.
Ok.  Now we have two extent trees - the first one is used to implement
extent locking while the second one is used to map logical blocks to
physical blocks.  If we protect operations on the two trees by
i_data_sem, then two trees are synced.  For example, given that a
process wants to modify a tree, it has to acquire i_data_sem, then no
other processes can access any tree.


Maybe I am overlooking something.:-)

Yongqiang.
>
> Allison Henderson
>
>>
>>>
>>> Thx!
>>> Allison Henderson
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
