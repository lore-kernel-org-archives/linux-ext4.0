From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH V2 5/6] ext4: let ext4 maintian delayed extent trees
Date: Thu, 29 Sep 2011 11:45:26 +0300
Message-ID: <CAOQ4uxjJ=D-Vsa1bp7FhEGVvGouL9HOhGapoHvG+FnJ3y2ffwg@mail.gmail.com>
References: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>
	<1317272926-13303-6-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, jeff.liu@oracle.com,
	achender@linux.vnet.ibm.com, adityakali@google.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37563 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab1I2Ip1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2011 04:45:27 -0400
Received: by wyg34 with SMTP id 34so26412wyg.19
        for <linux-ext4@vger.kernel.org>; Thu, 29 Sep 2011 01:45:26 -0700 (PDT)
In-Reply-To: <1317272926-13303-6-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 29, 2011 at 8:08 AM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> This patch let ext4 maintain delayed extent trees.
>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =A0fs/ext4/ext4.h =A0 =A0 | =A0 =A01 +
> =A0fs/ext4/extents.c =A0| =A0 =A02 ++
> =A0fs/ext4/indirect.c | =A0 =A03 +++
> =A0fs/ext4/inode.c =A0 =A0| =A0 28 ++++++++++++++++++++++++++--
> =A0fs/ext4/super.c =A0 =A0| =A0 12 +++++++++++-
> =A05 files changed, 43 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index d3c6b97..177ec0a 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -519,6 +519,7 @@ struct ext4_new_group_data {
> =A0#define EXT4_GET_BLOCKS_PUNCH_OUT_EXT =A0 =A0 =A0 =A0 =A00x0020
> =A0 =A0 =A0 =A0/* Don't normalize allocation size (used for fallocate=
) */
> =A0#define EXT4_GET_BLOCKS_NO_NORMALIZE =A0 =A0 =A0 =A0 =A0 0x0040
> +#define EXT4_GET_BLOCKS_DEALLOC =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A00x0080

typo + unused macro ?

Cheers,
Amir.

>
> =A0/*
> =A0* Flags used by ext4_free_blocks
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 9124cd2..bdbb984 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3688,6 +3688,8 @@ void ext4_ext_truncate(struct inode *inode)
>
> =A0 =A0 =A0 =A0last_block =3D (inode->i_size + sb->s_blocksize - 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0>> EXT4_BLOCK_SIZE_BIT=
S(sb);
> + =A0 =A0 =A0 err =3D ext4_de_remove_space(inode, last_block,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
EXT_MAX_BLOCKS - last_block);
> =A0 =A0 =A0 =A0err =3D ext4_ext_remove_space(inode, last_block);
>
> =A0 =A0 =A0 =A0/* In a multi-transaction truncate, we only make the f=
inal
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 0962642..25cdb5b 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -22,6 +22,7 @@
>
> =A0#include <linux/module.h>
> =A0#include "ext4_jbd2.h"
> +#include "ext4_extents.h"
> =A0#include "truncate.h"
>
> =A0#include <trace/events/ext4.h>
> @@ -1383,6 +1384,8 @@ void ext4_ind_truncate(struct inode *inode)
> =A0 =A0 =A0 =A0down_write(&ei->i_data_sem);
>
> =A0 =A0 =A0 =A0ext4_discard_preallocations(inode);
> + =A0 =A0 =A0 ext4_de_remove_space(inode, last_block,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT_MAX_BLOC=
KS - last_block);
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * The orphan list entry will now protect us from any =
crash which
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f86b149..0f9f108 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -442,7 +442,15 @@ int ext4_map_blocks(handle_t *handle, struct ino=
de *inode,
> =A0 =A0 =A0 =A0up_read((&EXT4_I(inode)->i_data_sem));
>
> =A0 =A0 =A0 =A0if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 int ret =3D check_block_validity(inode,=
 map);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flags & EXT4_GET_BLOCKS_DELALLOC_RE=
SERVE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* delayed alloc may be=
 allocated by fallocate,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* we need to handle =
delayed extent here.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 down_write((&EXT4_I(ino=
de)->i_data_sem));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto delayed_mapped;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D check_block_validity(inode, map=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ret;
> =A0 =A0 =A0 =A0}
> @@ -517,8 +525,18 @@ int ext4_map_blocks(handle_t *handle, struct ino=
de *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(flags & EXT4_GET_BLOC=
KS_DELALLOC_RESERVE))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_da_update_reserve=
_space(inode, retval, 1);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
> + =A0 =A0 =A0 if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_clear_inode_state(inode, EXT4_STA=
TE_DELALLOC_RESERVED);
> +delayed_mapped:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retval > 0 && map->m_flags & EXT4_M=
AP_MAPPED) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* delayed allocation b=
locks has been allocated */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_de_remove_=
space(inode, map->m_lblk,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0map->m_len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =
=3D ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0up_write((&EXT4_I(inode)->i_data_sem));
> =A0 =A0 =A0 =A0if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
> @@ -1630,6 +1648,12 @@ static int ext4_da_get_block_prep(struct inode=
 *inode, sector_t iblock,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* not enough space to=
 reserve */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ret;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 down_write((&EXT4_I(inode)->i_data_sem)=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_de_add_space(inode, map.m_=
lblk, map.m_len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 up_write((&EXT4_I(inode)->i_data_sem));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0map_bh(bh, inode->i_sb, invalid_block)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_buffer_new(bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_buffer_delay(bh);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 247fcdd..a248551 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -49,6 +49,7 @@
> =A0#include "xattr.h"
> =A0#include "acl.h"
> =A0#include "mballoc.h"
> +#include "ext4_extents.h"
>
> =A0#define CREATE_TRACE_POINTS
> =A0#include <trace/events/ext4.h>
> @@ -967,6 +968,7 @@ void ext4_clear_inode(struct inode *inode)
> =A0 =A0 =A0 =A0end_writeback(inode);
> =A0 =A0 =A0 =A0dquot_drop(inode);
> =A0 =A0 =A0 =A0ext4_discard_preallocations(inode);
> + =A0 =A0 =A0 ext4_de_remove_space(inode, 0, EXT_MAX_BLOCKS);
> =A0 =A0 =A0 =A0if (EXT4_I(inode)->jinode) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jbd2_journal_release_jbd_inode(EXT4_JO=
URNAL(inode),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 EXT4_I(inode)->jinode);
> @@ -4976,9 +4978,14 @@ static int __init ext4_init_fs(void)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0init_waitqueue_head(&ext4__ioend_wq[i]=
);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 err =3D ext4_init_pageio();
> + =A0 =A0 =A0 err =3D ext4_init_de();
> =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
> +
> + =A0 =A0 =A0 err =3D ext4_init_pageio();
> + =A0 =A0 =A0 if (err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out8;
> +
> =A0 =A0 =A0 =A0err =3D ext4_init_system_zone();
> =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out7;
> @@ -5030,6 +5037,9 @@ out6:
> =A0 =A0 =A0 =A0ext4_exit_system_zone();
> =A0out7:
> =A0 =A0 =A0 =A0ext4_exit_pageio();
> +out8:
> + =A0 =A0 =A0 ext4_exit_de();
> +
> =A0 =A0 =A0 =A0return err;
> =A0}
>
> --
> 1.7.5.1
>
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
