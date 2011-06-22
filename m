From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Wed, 22 Jun 2011 09:38:24 +0300
Message-ID: <BANLkTi=O2eR6JZTBiktbyCPsTgCGiPCTXg@mail.gmail.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
	<BANLkTimC9N6nLYg2+FqjVv_J4RGy1t8nZA@mail.gmail.com>
	<0A68B7C0-C7DD-456C-BC52-A169C5521933@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33684 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab1FVGiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jun 2011 02:38:25 -0400
Received: by wyb38 with SMTP id 38so325269wyb.19
        for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 23:38:24 -0700 (PDT)
In-Reply-To: <0A68B7C0-C7DD-456C-BC52-A169C5521933@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 21, 2011 at 6:45 PM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-06-21, at 5:06 AM, "Amir G." <amir73il@users.sourceforge.net>=
 wrote:
>> On Tue, Jun 7, 2011 at 6:07 PM, =A0<amir73il@users.sourceforge.net> =
wrote:
>>>
>>> I am resending the snapshots patch series as per Lukas's request.
>>> This time, the snapshot*.c files have not been omitted, as in
>>> the previous posting.
>>>
>>> The series is still based on ext4 dev branch sometime in the prepar=
ation
>>> for 3.0 merge window. It was not yet rebased on 3.0-rc1, so punch h=
oles
>>> changes have not been addressed yet.
>>>
>>> As always, I advocate online review of the patches at:
>>> https://github.com/amir73il/ext4-snapshots/commits/for-ext4-v1
>>> but if you insist on doing it the old way, I won't complain.
>>>
>>>
>>
>> To answer your question about possible diet to snapshot patches,
>> following are some diffstat on groups of patches (by functionality).
>> The diffsstat includes only ext4 core file (excluding new snapshot* =
files).
>>
>> As you can see, removing the shrink/merge functionality for multiple
>> snapshots, will remove the need for exclude bitmap and reduce the ch=
anges
>> to core files by ~300 insertions.
>>
>> There is some advantage of not having to add the exclude bitmap to e=
xisting
>> fs, but I think the win is not so big, assuming that we will want to=
 have the
>> shrink/merge functionality eventually.
>
> Wouldn't that also mean if shrink/merge are added later it needs anot=
her feature flag and added complexity due to another row in the feature=
 test matrix?
>

Sure, it would add another row in the matrix and we don't want that eit=
her.
Shrink/merge capability could be derived from the exclude_bitmap
(compatible) feature.
In fact, without exclude bitmap, shrink/merge can still be done, but
the shrink will
not be as efficient as with exclude_bitmap, but the shrink code works
just the same
(i.e. it doesn't have to check for exclude_bitmap feature).

BTW, I have just learned that ZFS disk space is not reclaimed at all
unless deleting
a complete part of the snapshots history (including the oldest).
This is essentially how ext4 snapshots would work without the
shrink/merge patches
and exclude_bitmap, but it is not very useful for long snapshot
retention policies
(i.e. 1 yearly, 3 monthly, 4 weekly,...).


>
>>
>>> [PATCH v1 01/36] ext4: EXT4 snapshots (Experimental)
>>> [PATCH v1 02/36] ext4: snapshot debugging support
>>
>> Generic stuff.
>>
>> 15 files changed, 122 insertions(+), 1 deletions(-)
>>
>>> [PATCH v1 03/36] ext4: snapshot hooks - inside JBD hooks
>>> [PATCH v1 04/36] ext4: snapshot hooks - block bitmap access
>>> [PATCH v1 05/36] ext4: snapshot hooks - delete blocks
>>> [PATCH v1 06/36] ext4: snapshot hooks - move data blocks
>>> [PATCH v1 07/36] ext4: snapshot hooks - direct I/O
>>> [PATCH v1 08/36] ext4: snapshot hooks - move extent file data block=
s
>>
>> Most of the code in this group handles MOW.
>>
>> 7 files changed, 550 insertions(+), 68 deletions(-)
>>
>>> [PATCH v1 09/36] ext4: snapshot file
>>> [PATCH v1 10/36] ext4: snapshot file - read through to block device
>>> [PATCH v1 11/36] ext4: snapshot file - permissions
>>> [PATCH v1 12/36] ext4: snapshot file - store on disk
>>> [PATCH v1 13/36] ext4: snapshot file - increase maximum file size l=
imit to 16TB
>>
>> Implementation of special snapshot file.
>>
>> 7 files changed, 220 insertions(+), 14 deletions(-)
>>
>>> [PATCH v1 14/36] ext4: snapshot block operations
>>> [PATCH v1 15/36] ext4: snapshot block operation - copy blocks to sn=
apshot
>>> [PATCH v1 16/36] ext4: snapshot block operation - move blocks to sn=
apshot
>>> [PATCH v1 17/36] ext4: snapshot block operation - copy block bitmap=
 to snapshot
>>
>> Copy/move to snapshot file operations.
>>
>> 5 files changed, 126 insertions(+), 24 deletions(-)
>>
>>> [PATCH v1 18/36] ext4: snapshot control
>>> [PATCH v1 19/36] ext4: snapshot control - init new snapshot
>>> [PATCH v1 20/36] ext4: snapshot control - fix new snapshot
>>> [PATCH v1 21/36] ext4: snapshot control - reserve disk space for sn=
apshot
>>
>> Mostly new code in ioctl.c.
>>
>> 6 files changed, 171 insertions(+), 3 deletions(-)
>>
>>> [PATCH v1 22/36] ext4: snapshot journaled - increase transaction cr=
edits
>>> [PATCH v1 23/36] ext4: snapshot journaled - implement journal_relea=
se_buffer()
>>> [PATCH v1 24/36] ext4: snapshot journaled - bypass to save credits
>>> [PATCH v1 25/36] ext4: snapshot journaled - cache last COW tid in j=
ournal_head
>>
>> Helper functions to handle extra COW credits.
>>
>> 7 files changed, 284 insertions(+), 31 deletions(-)
>>
>>> [PATCH v1 26/36] ext4: snapshot journaled - trace COW/buffer credit=
s
>>
>> Trace/debug for extra COW credits.
>>
>> 3 files changed, 108 insertions(+), 0 deletions(-)
>>
>>> [PATCH v1 27/36] ext4: snapshot list support
>>> [PATCH v1 28/36] ext4: snapshot list - read through to previous sna=
pshot
>>
>> Not much to gain from dropping snapshot list support...
>>
>> 2 files changed, 2 insertions(+), 0 deletions(-)
>>
>>> [PATCH v1 29/36] ext4: snapshot race conditions - concurrent COW bi=
tmap operations
>>> [PATCH v1 30/36] ext4: snapshot race conditions - concurrent COW op=
erations
>>> [PATCH v1 31/36] ext4: snapshot race conditions - tracked reads
>>
>> We must handle race conditions.
>>
>> 2 files changed, 32 insertions(+), 0 deletions(-)
>>
>>> [PATCH v1 32/36] ext4: snapshot exclude - the exclude bitmap
>>
>> We do not need the exclude bitmap if we do not shrink/merge snapshot=
s.
>>
>> 5 files changed, 226 insertions(+), 3 deletions(-)
>>
>>> [PATCH v1 33/36] ext4: snapshot cleanup
>>> [PATCH v1 34/36] ext4: snapshot cleanup - shrink deleted snapshots
>>> [PATCH v1 35/36] ext4: snapshot cleanup - merge shrunk snapshots
>>
>> We could support multiple snapshots without shrinking/merging delete=
d snapshot,
>> but that means that only disk space of oldest snapshot is reclaimed =
on delete.
>>
>> 2 files changed, 74 insertions(+), 22 deletions(-)
>>
>>> [PATCH v1 36/36] ext4: snapshot rocompat - enable rw mount
>>>
>>> =A0fs/ext4/Kconfig =A0 =A0 =A0 =A0 =A0 | =A0 11 +
>>> =A0fs/ext4/Makefile =A0 =A0 =A0 =A0 =A0| =A0 =A03 +
>>> =A0fs/ext4/balloc.c =A0 =A0 =A0 =A0 =A0| =A0132 +++
>>> =A0fs/ext4/ext4.h =A0 =A0 =A0 =A0 =A0 =A0| =A0188 ++++-
>>> =A0fs/ext4/ext4_jbd2.c =A0 =A0 =A0 | =A0162 ++++-
>>> =A0fs/ext4/ext4_jbd2.h =A0 =A0 =A0 | =A0266 ++++++-
>>> =A0fs/ext4/extents.c =A0 =A0 =A0 =A0 | =A0157 ++++-
>>> =A0fs/ext4/file.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 11 +-
>>> =A0fs/ext4/ialloc.c =A0 =A0 =A0 =A0 =A0| =A0 19 +-
>>> =A0fs/ext4/inode.c =A0 =A0 =A0 =A0 =A0 | =A0668 +++++++++++++--
>>> =A0fs/ext4/ioctl.c =A0 =A0 =A0 =A0 =A0 | =A0120 +++
>>> =A0fs/ext4/mballoc.c =A0 =A0 =A0 =A0 | =A0161 ++++-
>>> =A0fs/ext4/move_extent.c =A0 =A0 | =A0 =A03 +-
>>> =A0fs/ext4/namei.c =A0 =A0 =A0 =A0 =A0 | =A0 =A09 +
>>> =A0fs/ext4/resize.c =A0 =A0 =A0 =A0 =A0| =A0 19 +-
>>> =A0fs/ext4/snapshot.c =A0 =A0 =A0 =A0| 1000 ++++++++++++++++++++++
>>> =A0fs/ext4/snapshot.h =A0 =A0 =A0 =A0| =A0690 ++++++++++++++++
>>> =A0fs/ext4/snapshot_buffer.c | =A0393 +++++++++
>>> =A0fs/ext4/snapshot_ctl.c =A0 =A0| 2002 +++++++++++++++++++++++++++=
++++++++++++++++++
>>> =A0fs/ext4/snapshot_debug.c =A0| =A0107 +++
>>> =A0fs/ext4/snapshot_debug.h =A0| =A0105 +++
>>> =A0fs/ext4/snapshot_inode.c =A0| =A0960 ++++++++++++++++++++++
>>> =A0fs/ext4/super.c =A0 =A0 =A0 =A0 =A0 | =A0157 ++++-
>>> =A0fs/ext4/xattr.c =A0 =A0 =A0 =A0 =A0 | =A0 =A04 +-
>>> =A024 files changed, 7182 insertions(+), 165 deletions(-)
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
