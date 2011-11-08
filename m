From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH V3 0/15] ext4: add new online resize interface
Date: Tue, 8 Nov 2011 16:38:30 +0800
Message-ID: <CAGBYx2bfFva5n8X+Nuwjzu-5bZRVYGLx20YZyx=aH9EgKO5EGQ@mail.gmail.com>
References: <1320707608-14246-1-git-send-email-xiaoqiangnk@gmail.com>
	<B6C5796D-0A41-4131-A947-9BF554B8CEFD@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56565 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1KHIib convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Nov 2011 03:38:31 -0500
Received: by qao25 with SMTP id 25so129516qao.19
        for <linux-ext4@vger.kernel.org>; Tue, 08 Nov 2011 00:38:30 -0800 (PST)
In-Reply-To: <B6C5796D-0A41-4131-A947-9BF554B8CEFD@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 8, 2011 at 3:06 PM, Andreas Dilger <adilger@dilger.ca> wrot=
e:
> On 2011-11-07, at 4:13 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> wro=
te:
>
>> Hi all,
>>
>> V2->V3:
>> =A0 initialize block bitmap of last group.
>> =A0 remove code initalizing inode bitmap and inode tables.
>
> Thanks for the great work. I haven't looked through the patches yet, =
but just a high level question...
>
>> This patch series adds new resize implementation to ext4.
>>
>> -- What's new resize implementation?
>> =A0 It is a new online resize interface for ext4. =A0It can be used =
via
>> =A0 ioctl with EXT4_IOC_RESIZE_FS and a 64 bit integer indicating si=
ze
>> =A0 of the resized fs in block.
>>
>> -- Difference between current resize and new resize.
>> =A0 New resize lets kernel do all work, like allocating bitmaps and
>> =A0 inode tables and can support flex_bg and BLOCK_UNINIT features.
>> =A0 Besides these, new resize is much faster than current resize.
>
> Does this also support META_BG filesystems? =A0One major limitation o=
f
NO:-)  The intention of this patch series is to enable a new online
resize interface which receives a block count indicating the size the
filesystem is expected to be.  So in new online resize, everything
except new size of filesystems is done in kernel, such as allocating
group tables.  After this patch series merged, any changes on online
resize can be easily undertaken, like supporting snapshot.

the current resize implementation is that mke2fs does not prepare
filesystems over 16TB for resizing. =A0With METABG it would be possible
to online resize without any preparation. One drawback of METABG is
that there is no backup group descriptor for the last group if it is
the only one in the METABG. I recall Ted had a suggestion to add a GDT
backup for the last group in the superblock (maybe at the end), since
it is only 64 bytes big, and this could be done compatibly under the
METABG flag, since an all-zero backup for an old fs (if there are any)
is no worse that no backup at all.
>
> It is also not currently possible to resize from a sub-16TB filesyste=
m to above 16TB. =A0Did you test with a 64-byte group descriptor for fi=
lesystemsbelow 16TB?
YES.   I tested with a disk with 220GB capacity.

>
> These aren't at all reasons to reject this patch series, but since yo=
u are in the middle of working on this code it might be easier for you =
to implement this functionality if it isn't already in the patches.

Yes.  I can add meta_bg support after the patch series merged.

Yongqiang.
>
>> =A0 Below are benchmarks I made on my personal computer, fses with
>> =A0 flex_bg size =3D 16 were resized to 230GB evry time. The first
>> =A0 row shows the size of a fs from which the fs was resized to 230G=
B.
>> =A0 The datas were collected by 'time resize2fs'.
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0new resize
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A020GB =A0 =A0 =A0 =A0 =A050GB =A0 =A0 =
=A0100GB
>> =A0 =A0 =A0real =A0 =A00m3.558s =A0 =A0 0m2.891s =A0 =A00m0.394s
>> =A0 =A0 =A0user =A0 =A00m0.004s =A0 =A0 0m0.000s =A0 =A00m0.394s
>> =A0 =A0 =A0sys =A0 =A0 0m0.048s =A0 =A0 0m0.048s =A0 =A00m0.028s
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0current resize
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A020GB =A0 =A0 =A0 =A0 =A050GB =A0 =A0 =
=A0100GB
>> =A0 =A0 =A0real =A0 =A05m2.770s =A0 =A0 4m43.757s =A03m14.840s
>> =A0 =A0 =A0user =A0 =A00m0.040s =A0 =A0 0m0.032s =A0 0m0.024s
>> =A0 =A0 =A0sys =A0 =A0 0m0.464s =A0 =A0 0m0.432s =A0 0m0.324s
>>
>> =A0 According to data above, new resize is faster than current resiz=
e in both
>> =A0 user and sys time. =A0New resize performs well in sys time, beca=
use it
>> =A0 supports BLOCK_UNINIT and adds multi-groups each time.
>>
>> -- About supporting new features.
>> =A0 YES! New resize can support new feature like bigalloc and exclud=
e bitmap
>> =A0 easily. =A0Because it lets kernel do all work.
>>
>> Yongqiang.
>>
>> git diff --stat
>>
>> Documentation/filesystems/ext4.txt | =A0 =A07 +
>> fs/ext4/ext4.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 10 +
>> fs/ext4/ioctl.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 39 ++
>> fs/ext4/resize.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | 1167 ++++++++=
+++++++++++++++++++---------
>> 4 files changed, 942 insertions(+), 281 deletions(-)
>>
>> [PATCH V3 01/15] ext4: add a function which extends a group without
>> [PATCH V3 02/15] ext4: add a function which adds a new desc to a fs
>> [PATCH V3 03/15] ext4: add a function which sets up a new group desc
>> [PATCH V3 04/15] ext4: add a function which updates super block
>> [PATCH V3 05/15] ext4: add a structure which will be used by
>> [PATCH V3 06/15] ext4: add a function which sets up group blocks of
>> [PATCH V3 07/15] ext4: add a function which adds several group
>> [PATCH V3 08/15] ext4: add a function which sets up a flex groups
>> [PATCH V3 09/15] ext4: enable ext4_update_super() to handle a flex
>> [PATCH V3 10/15] ext4: pass verify_reserved_gdb() the number of
>> [PATCH V3 11/15] ext4: add a new function which allocates bitmaps
>> [PATCH V3 12/15] ext4: add a new function which adds a flex group to
>> [PATCH V3 13/15] ext4: add new online resize interface
>> [PATCH V3 14/15] ext4: let ext4_group_extend() use common code
>> [PATCH V3 15/15] ext4: let ext4_group_add() use common code
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
