From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] ext4: Try to better reuse recently freed space
Date: Mon, 8 Jul 2013 15:27:21 -0600
Message-ID: <0D534283-4B81-45CA-B7D2-E2857F0EAB85@dilger.ca>
References: <alpine.LFD.2.00.1307041730590.30302@localhost.localdomain> <1373269107-9678-1-git-send-email-lczerner@redhat.com> <20130708085603.GB5988@quack.suse.cz> <alpine.LFD.2.00.1307081108380.1843@localhost.localdomain> <20130708115951.GC5988@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
	Alex Zhuravlev <alexey.zhuravlev@intel.com>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:35097 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3GHV1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jul 2013 17:27:24 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so4709056pbb.8
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jul 2013 14:27:23 -0700 (PDT)
In-Reply-To: <20130708115951.GC5988@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-07-08, at 5:59 AM, Jan Kara wrote:
> On Mon 08-07-13 11:24:01, Luk=E1=9A Czerner wrote:
>> On Mon, 8 Jul 2013, Jan Kara wrote:
>>> On Mon, 8 Jul 2013, Jan Kara <jack@suse.cz> wrote:
>>> On Mon 08-07-13 09:38:27, Lukas Czerner wrote:
>>>> Currently if the block allocator can not find the goal to
>>>> allocate we would use global goal for stream allocation.
>>>> However the global goal (s_mb_last_group and s_mb_last_start) will=
 move further every time such allocation appears and
>>>> never move backwards.
>>>>=20
>>>> This causes several problems in certain scenarios:
>>>> - the goal will move further and further preventing us from
>>>>   reusing space which might have been freed since then. This
>>>>   is ok from the file system point of view because we will
>>>>   reuse that space eventually, however we're allocating block
>>>>   from slower parts of the spinning disk even though it might
>>>>   not be necessary.
>>>> - The above also causes more serious problem for example for
>>>>   thinly  provisioned storage (sparse images backed storage
>>>>   as well), because instead of reusing blocks which are
>>>>   already provisioned we would try to use new blocks. This
>>>>   would unnecessarily drain storage free blocks pool.
>>>> - This will also cause blocks to be allocated further from
>>>>   the given goal than it's necessary. Consider for example
>>>>   truncating, or removing and rewriting the file in the loop.
>>>> This workload will never reuse freed blocks until we continually
>>>> claim and free all the block in the file system.
>>>>=20
>>>> Note that file systems like xfs, ext3, or btrfs does not have this=
 problem. This is simply caused by the notion of global pool.
>>>>=20
>>>> Fix this by changing the global goal to be goal per inode. This wi=
ll allow us to invalidate the goal every time the inode has
>>>> been truncated, or newly created, so in those cases we would try
>>>> to use the proper more specific goal which is based on inode
>>>> position.
>>> When looking at your patch for second time, I started wondering,
>>> whether we need per-inode stream goal at all. We already do set
>>> goal in the allocation request for mballoc (ar->goal) e.g. in
>>> ext4_ext_find_goal().
>>> It seems strange to then reset it inside mballoc and I don't
>>> even think mballoc will change it to something else now when
>>> the goal is per-inode and not global.
>>=20
>> Yes, we do set the goal in the allocation request and it is supposed
>> to be the "best" goal. However sometimes it can not be fulfilled
>> because we do not have any free block at "goal".
>>=20
>> That's when the global (or per-inode) goal comes into play. I suppos=
e
>> that there was several reasons for that. First of all it makes it
>> easier for allocator, because it can directly jump at the point
>> where we allocated last time and it is likely that there is some
>> free space to allocate from - so the benefit is that we do not have
>> to walk all the space in between which is likely to be allocated.
>=20
> Yep, but my question is: If we have per-inode streaming goal, can
> you show an example when the "best" goal will be different from the
> "streaming" goal? Because from a (I admit rather quick) look at how
> each of these is computed, it seems that both will point after the
> next allocated block in case of streaming IO.

There were a few goals with the design of the mballoc allocator:
- keep large allocations sized and aligned on RAID chunks
- pack small allocations together, so they can fit into a
  single RAID chunk and avoid many read-modify-write cycles
- keep allocations relatively close together, so that seeking is
  minimized and it doesn't search through fragmented free space

It was designed for high-bandwidth streaming IO, and not small random I=
O as is seen with VM images and thin-provisioned storage.  That said, w=
ith TRIM and sparse storage, there is no guarantee that offset within t=
he virtual device has any association with the real disk, so I'm not su=
re it makes sense to optimize for this case.

The ext4 code will already bias new allocations towards the beginning o=
f the disk because this is how inodes are allocated and this influences=
 each inode's block allocation.  The global target allows the large all=
ocations to get out of the mess of fragmented free space and into other=
 parts of the filesystem that are not as heavily used.

Rather than tweaking the global target (which is currently just a simpl=
e round-robin), it probably makes sense to look at a global extent map =
for free space, so that it is easier to find large chunks of free space=
=2E  It is still desirable to keep these allocations closer together, o=
therwise the "optimum" location for several large allocations may be on=
 different ends of the disk and the situation would be far worse than m=
aking periodic writes over the whole disk.

Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
