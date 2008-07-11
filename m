From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix lock order during truncate.
Date: Fri, 11 Jul 2008 16:00:21 -0700
Message-ID: <1215817221.6558.33.camel@mingming-laptop>
References: <1215680164-15846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:34562 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYGKXAa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jul 2008 19:00:30 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6BN0TU0003158
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jul 2008 19:00:29 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6BN0TWY161266
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jul 2008 17:00:29 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6BN0Ss2023927
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jul 2008 17:00:29 -0600
In-Reply-To: <1215680164-15846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-10=E5=9B=9B=E7=9A=84 14:26 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> This can be merged to
> ext4-fix-lock-inversion-in-ext4_ext_truncate.patch
>=20
>=20

Looks good to me.
=46olded this fix to  ext4-fix-lock-inversion-in-ext4_ext_truncate.patc=
h
in patch queue


Mingming
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> [ INFO: possible circular locking dependency detected ]
> 2.6.26-rc8 #32
> -------------------------------------------------------
> umount/4921 is trying to acquire lock:
>  (&ei->i_data_sem){----}, at: [<c01dd2c1>] ext4_get_blocks_wrap+0x29/=
0x120
>=20
> but task is already holding lock:
>  (&type->s_lock_key#7){--..}, at: [<c0169211>] lock_super+0x1b/0x1d
>=20
> which lock already depends on the new lock.
>=20
>=20
> the existing dependency chain (in reverse order) is:
>=20
> -> #1 (&type->s_lock_key#7){--..}:
>        [<c013c820>] __lock_acquire+0x97f/0xb32
>        [<c013ca3f>] lock_acquire+0x6c/0x89
>        [<c0442dc4>] mutex_lock_nested+0xc9/0x248
>        [<c0169211>] lock_super+0x1b/0x1d
>        [<c01e2f71>] ext4_orphan_del+0x21/0x162
>        [<c01ecaec>] ext4_ext_truncate+0x114/0x167
>        [<c01dde2d>] ext4_truncate+0x84/0x40d
>        [<c01582cb>] vmtruncate+0x103/0x129
>        [<c01799ac>] inode_setattr+0x67/0x139
>        [<c01df73c>] ext4_setattr+0x27b/0x2fa
>        [<c0179bab>] notify_change+0x12d/0x2a6
>        [<c016719b>] do_truncate+0x62/0x7b
>        [<c01672d9>] do_sys_ftruncate+0x125/0x142
>        [<c0167312>] sys_ftruncate64+0x1c/0x24
>        [<c0103949>] sysenter_past_esp+0x6a/0xb1
>        [<ffffffff>] 0xffffffff
>=20
> -> #0 (&ei->i_data_sem){----}:
>        [<c013c747>] __lock_acquire+0x8a6/0xb32
>        [<c013ca3f>] lock_acquire+0x6c/0x89
>        [<c044330a>] down_read+0x2b/0x65
>        [<c01dd2c1>] ext4_get_blocks_wrap+0x29/0x120
>        [<c01dd634>] ext4_get_block+0xa2/0xd7
>        [<c01843f2>] generic_block_bmap+0x43/0x50
>        [<c01de6de>] ext4_bmap+0x8d/0x96
>        [<c01783d5>] bmap+0x26/0x2b
>        [<c02070ee>] jbd2_journal_bmap+0x20/0x75
>        [<c02072ae>] jbd2_journal_next_log_block+0x61/0x67
>        [<c0207b44>] jbd2_journal_get_descriptor_buffer+0x13/0x90
>        [<c0202f73>] journal_submit_commit_record+0x2f/0x19a
>        [<c0203bb7>] jbd2_journal_commit_transaction+0xabf/0x1038
>        [<c02069f9>] jbd2_journal_destroy+0xc8/0x1c9
>        [<c01e5835>] ext4_put_super+0x35/0x1ab
>        [<c0169a1a>] generic_shutdown_super+0x52/0xd3
>        [<c0169aaa>] kill_block_super+0xf/0x20
>        [<c0169b63>] deactivate_super+0x57/0x6a
>        [<c017b6f3>] mntput_no_expire+0xba/0xdd
>        [<c017bb95>] sys_umount+0x259/0x29b
>        [<c0103949>] sysenter_past_esp+0x6a/0xb1
>        [<ffffffff>] 0xffffffff
>=20
> other info that might help us debug this:
>=20
> 2 locks held by umount/4921:
>  #0:  (&type->s_umount_key#17){----}, at: [<c0169b5e>] deactivate_sup=
er+0x52/0x6a
>  #1:  (&type->s_lock_key#7){--..}, at: [<c0169211>] lock_super+0x1b/0=
x1d
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 48b8764..7bbc095 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2971,6 +2971,7 @@ void ext4_ext_truncate(struct inode *inode)
>  		handle->h_sync =3D 1;
>=20
>  out_stop:
> +	up_write(&EXT4_I(inode)->i_data_sem);
>  	/*
>  	 * If this was a simple ftruncate() and the file will remain alive,
>  	 * then we need to clear up the orphan record which we created abov=
e.
> @@ -2981,7 +2982,6 @@ void ext4_ext_truncate(struct inode *inode)
>  	if (inode->i_nlink)
>  		ext4_orphan_del(handle, inode);
>=20
> -	up_write(&EXT4_I(inode)->i_data_sem);
>  	inode->i_mtime =3D inode->i_ctime =3D ext4_current_time(inode);
>  	ext4_mark_inode_dirty(handle, inode);
>  	ext4_journal_stop(handle);

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
