From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Tue, 7 Jun 2011 19:31:58 +0300
Message-ID: <BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56403 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab1FGQcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 12:32:00 -0400
In-Reply-To: <alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 7, 2011 at 6:56 PM, Lukas Czerner <lczerner@redhat.com> wro=
te:
> Hi Amir,
>
> thanks very much for the resend. I'll take a look at the whole patch
> series, but first I want to bring up one important thing.
>
> While this being a huge feature for ext4 (regardless on how
> intrusive it is for the usual code paths) and while we already have
> patches in the list with people interesting in looking into them, you
> should clearly clarify what is the gain of it, what is the use case (=
and
> I know you have one), and why it is better than other approaches. You
> know, advertise it a bit in the marketing way :).

Hi Lukas,

Thank you for pointing out the marketing aspect.

I must admit that my user-case rather speaks for itself.
CTERA develops a NAS device which is specialized for
backing up local networks and snapshots gives the NAS a time
dimension without paying for it in disk space and performance.

The reason for not going with btrfs 3 years ago is clear.
So why not go with it now instead of moving forward to
ext4 with snapshots?
Part of the answer lies in the possibility to run fsck -x,
which gets rid of the snapshots in the case of fs corruption
and gets you back to good old stable and consistent ext4.

>
> There is some confusion among developers on what actually are benefit=
s
> of ext4 snapshots in comparison to btrfs, or in comparison to the new
> dm_multisnap code. I know that you have done quite a lot of testing t=
o
> assure that it does not actually change old ext4 behavior when snapsh=
ot
> disabled, and that it works well when enabled, but have you done any
> performance related benchmarks ? Do you have any expectations on how =
it
> should behave in different work loads ?
>
> It would be great to see and be able to confirm that ext4 snapshots a=
re
> really a win, not only on the feature side, but on the performance si=
de
> as well. I know that there are people out there still undecided or
> having a strange feeling about your snapshot work. But who can blame
> them, when we have not seen any hard data on this matter ?

Ehm.. I did present this benchmark on LSF:
http://global.phoronix-test-suite.com/index.php?k=3Dprofile&u=3Damir73i=
l-4632-11284-26560

unless you snoozed ;-)
it shows performance vs. ext4 w/o snapshots and with snapshots
and while taking snapshots.
I did not compare with btrfs, but I bet there are ext4 vs. btrfs
benchmarks out there.
dm-multisnap is better than dm-snap only when it comes to overhead
per snapshot. it still copies every written block, which is far from
being the case in ext4 snapshots.

>
> So I, for myself, and I believe there are others, would like to see s=
ome
> benchmark numbers and comparison (both, features and performance) wit=
h at
> least new dm-multisnap code and probably btrfs and plain ext4 as well=
=2E
>
> Thanks!
> -Lukas
>
>
> On Tue, 7 Jun 2011, amir73il@users.sourceforge.net wrote:
>
>> Hi All,
>>
>> I am resending the snapshots patch series as per Lukas's request.
>> This time, the snapshot*.c files have not been omitted, as in
>> the previous posting.
>>
>> The series is still based on ext4 dev branch sometime in the prepara=
tion
>> for 3.0 merge window. It was not yet rebased on 3.0-rc1, so punch ho=
les
>> changes have not been addressed yet.
>>
>> As always, I advocate online review of the patches at:
>> https://github.com/amir73il/ext4-snapshots/commits/for-ext4-v1
>> but if you insist on doing it the old way, I won't complain.
>>
>> Thanks,
>> Amir.
>>
>> [PATCH v1 01/36] ext4: EXT4 snapshots (Experimental)
>> [PATCH v1 02/36] ext4: snapshot debugging support
>> [PATCH v1 03/36] ext4: snapshot hooks - inside JBD hooks
>> [PATCH v1 04/36] ext4: snapshot hooks - block bitmap access
>> [PATCH v1 05/36] ext4: snapshot hooks - delete blocks
>> [PATCH v1 06/36] ext4: snapshot hooks - move data blocks
>> [PATCH v1 07/36] ext4: snapshot hooks - direct I/O
>> [PATCH v1 08/36] ext4: snapshot hooks - move extent file data blocks
>> [PATCH v1 09/36] ext4: snapshot file
>> [PATCH v1 10/36] ext4: snapshot file - read through to block device
>> [PATCH v1 11/36] ext4: snapshot file - permissions
>> [PATCH v1 12/36] ext4: snapshot file - store on disk
>> [PATCH v1 13/36] ext4: snapshot file - increase maximum file size li=
mit to 16TB
>> [PATCH v1 14/36] ext4: snapshot block operations
>> [PATCH v1 15/36] ext4: snapshot block operation - copy blocks to sna=
pshot
>> [PATCH v1 16/36] ext4: snapshot block operation - move blocks to sna=
pshot
>> [PATCH v1 17/36] ext4: snapshot block operation - copy block bitmap =
to snapshot
>> [PATCH v1 18/36] ext4: snapshot control
>> [PATCH v1 19/36] ext4: snapshot control - init new snapshot
>> [PATCH v1 20/36] ext4: snapshot control - fix new snapshot
>> [PATCH v1 21/36] ext4: snapshot control - reserve disk space for sna=
pshot
>> [PATCH v1 22/36] ext4: snapshot journaled - increase transaction cre=
dits
>> [PATCH v1 23/36] ext4: snapshot journaled - implement journal_releas=
e_buffer()
>> [PATCH v1 24/36] ext4: snapshot journaled - bypass to save credits
>> [PATCH v1 25/36] ext4: snapshot journaled - cache last COW tid in jo=
urnal_head
>> [PATCH v1 26/36] ext4: snapshot journaled - trace COW/buffer credits
>> [PATCH v1 27/36] ext4: snapshot list support
>> [PATCH v1 28/36] ext4: snapshot list - read through to previous snap=
shot
>> [PATCH v1 29/36] ext4: snapshot race conditions - concurrent COW bit=
map operations
>> [PATCH v1 30/36] ext4: snapshot race conditions - concurrent COW ope=
rations
>> [PATCH v1 31/36] ext4: snapshot race conditions - tracked reads
>> [PATCH v1 32/36] ext4: snapshot exclude - the exclude bitmap
>> [PATCH v1 33/36] ext4: snapshot cleanup
>> [PATCH v1 34/36] ext4: snapshot cleanup - shrink deleted snapshots
>> [PATCH v1 35/36] ext4: snapshot cleanup - merge shrunk snapshots
>> [PATCH v1 36/36] ext4: snapshot rocompat - enable rw mount
>>
>> =A0fs/ext4/Kconfig =A0 =A0 =A0 =A0 =A0 | =A0 11 +
>> =A0fs/ext4/Makefile =A0 =A0 =A0 =A0 =A0| =A0 =A03 +
>> =A0fs/ext4/balloc.c =A0 =A0 =A0 =A0 =A0| =A0132 +++
>> =A0fs/ext4/ext4.h =A0 =A0 =A0 =A0 =A0 =A0| =A0188 ++++-
>> =A0fs/ext4/ext4_jbd2.c =A0 =A0 =A0 | =A0162 ++++-
>> =A0fs/ext4/ext4_jbd2.h =A0 =A0 =A0 | =A0266 ++++++-
>> =A0fs/ext4/extents.c =A0 =A0 =A0 =A0 | =A0157 ++++-
>> =A0fs/ext4/file.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 11 +-
>> =A0fs/ext4/ialloc.c =A0 =A0 =A0 =A0 =A0| =A0 19 +-
>> =A0fs/ext4/inode.c =A0 =A0 =A0 =A0 =A0 | =A0668 +++++++++++++--
>> =A0fs/ext4/ioctl.c =A0 =A0 =A0 =A0 =A0 | =A0120 +++
>> =A0fs/ext4/mballoc.c =A0 =A0 =A0 =A0 | =A0161 ++++-
>> =A0fs/ext4/move_extent.c =A0 =A0 | =A0 =A03 +-
>> =A0fs/ext4/namei.c =A0 =A0 =A0 =A0 =A0 | =A0 =A09 +
>> =A0fs/ext4/resize.c =A0 =A0 =A0 =A0 =A0| =A0 19 +-
>> =A0fs/ext4/snapshot.c =A0 =A0 =A0 =A0| 1000 ++++++++++++++++++++++
>> =A0fs/ext4/snapshot.h =A0 =A0 =A0 =A0| =A0690 ++++++++++++++++
>> =A0fs/ext4/snapshot_buffer.c | =A0393 +++++++++
>> =A0fs/ext4/snapshot_ctl.c =A0 =A0| 2002 ++++++++++++++++++++++++++++=
+++++++++++++++++
>> =A0fs/ext4/snapshot_debug.c =A0| =A0107 +++
>> =A0fs/ext4/snapshot_debug.h =A0| =A0105 +++
>> =A0fs/ext4/snapshot_inode.c =A0| =A0960 ++++++++++++++++++++++
>> =A0fs/ext4/super.c =A0 =A0 =A0 =A0 =A0 | =A0157 ++++-
>> =A0fs/ext4/xattr.c =A0 =A0 =A0 =A0 =A0 | =A0 =A04 +-
>> =A024 files changed, 7182 insertions(+), 165 deletions(-)
>>
>>
>
> --
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
