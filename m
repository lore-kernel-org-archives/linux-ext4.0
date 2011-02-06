From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/5] mballoc: trivial code cleanup
Date: Sun, 6 Feb 2011 10:43:58 +0200
Message-ID: <AANLkTimT3i1oOSh02oTtvN_OmHcYwhNOABLV4cT7VV5p@mail.gmail.com>
References: <4D4E294E.4080507@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Alex Tomas <alex@clusterfs.com>,
	Theodore Tso <tytso@google.com>
To: i@coly.li
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48034 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1BFIoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Feb 2011 03:44:00 -0500
Received: by qwa26 with SMTP id 26so2824797qwa.19
        for <linux-ext4@vger.kernel.org>; Sun, 06 Feb 2011 00:43:59 -0800 (PST)
In-Reply-To: <4D4E294E.4080507@coly.li>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Coly,

=46orgive me for hijacking your thread.
I cannot comment on the cleanup, as I am new to mballoc code,
but I was wondering if you could offer me a piece of advise.

In the current implementation (prototype) of ext4 snapshots,
I have an outstanding circular lockdep warning to fix:
inode->i_data_sem =3D> grp->alloc_sem =3D> snapshot->i_data_sem/1 =3D> =
grp->alloc_sem

Snapshot block allocation can be nested inside another inode block allo=
cation,
because COW of bitmap block is triggered on get_write_access() inside
ext4_mb_mark_diskspace_used().
i_data_sem nested lockdep is handled by calling
down_read/write_nested() in ext4_map_blocks():
https://github.com/amir73il/ext4-snapshots/blob/ext4-snapshots/fs/ext4/=
inode.c#L1540

In ext3/next3, handling nested i_truncate_mutex lockdep was enough,
but in ext4, I need to take care of alloc_sem and lg_mutex as well.
I "handled" lg_mutex by never setting EXT4_MB_HINT_DATA on snapshot fil=
es.
When looking at alloc_sem, I realized that it is only needed to avoid
race with adjacent group buddy initialization.
Snapshots feature, however, requires that block_size =3D=3D page_size, =
so
it seems that alloc_sem
can be avoided altogether.

My questions are:

1. Am I missing something in my analysis?
2. Wouldn't it make sense to bypass alloc_sem at all times if
block_size =3D=3D page_size
(or block_size*2 >=3D page_size), regardless of the snapshots feature?
After all, a group buddy is always initialized before calling
allocation routines.

Thanks for your time,
Amir.


On Sun, Feb 6, 2011 at 6:53 AM, Coly Li <i@coly.li> wrote:
> This patch set contains several trivial code cleanup to mballoc code.
> A basic testing is done with Linux 2.6.38-rc3+ (commit 44f2c5c8).
>
> Signed-off-by: Coly Li <bosong.ly@taobao.com>
> Cc: Alex Tomas <alex@clusterfs.com>
> Cc: Theodore Tso <tytso@google.com>
> ---
> =A0fs/ext4/mballoc.c | =A0 15 ++++++++++-----
> =A0fs/ext4/mballoc.h | =A0 =A02 +-
> =A02 files changed, 11 insertions(+), 6 deletions(-)
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
