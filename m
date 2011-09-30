From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC PATCH V2 5/6] ext4: let ext4 maintian delayed extent trees
Date: Fri, 30 Sep 2011 10:08:50 +0800
Message-ID: <CAGBYx2YjSJ5pks4gM+9M0c=okTRXvsjbiQCb78NkO8QP_Kx3Kw@mail.gmail.com>
References: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>
	<1317272926-13303-6-git-send-email-xiaoqiangnk@gmail.com>
	<4E848124.6070500@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, jeff.liu@oracle.com,
	achender@linux.vnet.ibm.com, adityakali@google.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53986 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab1I3CIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2011 22:08:52 -0400
Received: by vws1 with SMTP id 1so998600vws.19
        for <linux-ext4@vger.kernel.org>; Thu, 29 Sep 2011 19:08:51 -0700 (PDT)
In-Reply-To: <4E848124.6070500@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 29, 2011 at 10:31 PM, Tao Ma <tm@tao.ma> wrote:
> On 09/29/2011 01:08 PM, Yongqiang Yang wrote:
>> This patch let ext4 maintain delayed extent trees.
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext4/ext4.h =A0 =A0 | =A0 =A01 +
>> =A0fs/ext4/extents.c =A0| =A0 =A02 ++
>> =A0fs/ext4/indirect.c | =A0 =A03 +++
>> =A0fs/ext4/inode.c =A0 =A0| =A0 28 ++++++++++++++++++++++++++--
>> =A0fs/ext4/super.c =A0 =A0| =A0 12 +++++++++++-
>> =A05 files changed, 43 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index d3c6b97..177ec0a 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -519,6 +519,7 @@ struct ext4_new_group_data {
>> =A0#define EXT4_GET_BLOCKS_PUNCH_OUT_EXT =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A00x0020
>> =A0 =A0 =A0 /* Don't normalize allocation size (used for fallocate) =
*/
>> =A0#define EXT4_GET_BLOCKS_NO_NORMALIZE =A0 =A0 =A0 =A0 0x0040
>> +#define EXT4_GET_BLOCKS_DEALLOC =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A00x0080
>>
>> =A0/*
>> =A0 * Flags used by ext4_free_blocks
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 9124cd2..bdbb984 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -3688,6 +3688,8 @@ void ext4_ext_truncate(struct inode *inode)
>>
>> =A0 =A0 =A0 last_block =3D (inode->i_size + sb->s_blocksize - 1)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 >> EXT4_BLOCK_SIZE_BITS(=
sb);
>> + =A0 =A0 err =3D ext4_de_remove_space(inode, last_block,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT=
_MAX_BLOCKS - last_block);
>> =A0 =A0 =A0 err =3D ext4_ext_remove_space(inode, last_block);
>>
>> =A0 =A0 =A0 /* In a multi-transaction truncate, we only make the fin=
al
>> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
>> index 0962642..25cdb5b 100644
>> --- a/fs/ext4/indirect.c
>> +++ b/fs/ext4/indirect.c
>> @@ -22,6 +22,7 @@
>>
>> =A0#include <linux/module.h>
>> =A0#include "ext4_jbd2.h"
>> +#include "ext4_extents.h"
>> =A0#include "truncate.h"
>>
>> =A0#include <trace/events/ext4.h>
>> @@ -1383,6 +1384,8 @@ void ext4_ind_truncate(struct inode *inode)
>> =A0 =A0 =A0 down_write(&ei->i_data_sem);
>>
>> =A0 =A0 =A0 ext4_discard_preallocations(inode);
>> + =A0 =A0 ext4_de_remove_space(inode, last_block,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT_MAX_BLOCKS =
- last_block);
>>
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* The orphan list entry will now protect us from any =
crash which
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index f86b149..0f9f108 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -442,7 +442,15 @@ int ext4_map_blocks(handle_t *handle, struct in=
ode *inode,
>> =A0 =A0 =A0 up_read((&EXT4_I(inode)->i_data_sem));
>>
>> =A0 =A0 =A0 if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 int ret =3D check_block_validity(inode, ma=
p);
>> + =A0 =A0 =A0 =A0 =A0 =A0 int ret;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (flags & EXT4_GET_BLOCKS_DELALLOC_RESER=
VE) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* delayed alloc may be al=
located by fallocate,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* we need to handle del=
ayed extent here.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 down_write((&EXT4_I(inode)=
->i_data_sem));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto delayed_mapped;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D check_block_validity(inode, map);
> I am not quite sure of this. So do you mean when we write_begin the
> extent isn't allocated, while in the time of writepage, the extent is
> fallocted, right? If this is the case, where do we update the reserve=
_space?
> I mean in ext4_da_get_block_prep, we call ext4_da_reserve_space, and =
if
> there is no fallocate, we will call ext4_da_update_reserve_space in
> ext4_ext_handle_uninitialized_extents. So in your case, the 2nd
> ext4_da_update_reserve_space wouldn't be called. I am not sure whethe=
r
> there will be some problem or not.
Hi  Tao,

What if fallocated blocks have been allocated by direct I/O?  I placed
a BUG() here, it was indeed triggered by xfstests 127.

The comment is not clear, sorry for that.

Yongqiang.
>
> Thanks
> Tao
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret !=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
>> =A0 =A0 =A0 }
>> @@ -517,8 +525,18 @@ int ext4_map_blocks(handle_t *handle, struct in=
ode *inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (flags & EXT4_GET_BLOCKS=
_DELALLOC_RESERVE))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_da_update_reserve_s=
pace(inode, retval, 1);
>> =A0 =A0 =A0 }
>> - =A0 =A0 if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
>> + =A0 =A0 if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_clear_inode_state(inode, EXT4_STATE=
_DELALLOC_RESERVED);
>> +delayed_mapped:
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (retval > 0 && map->m_flags & EXT4_MAP_=
MAPPED) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int ret;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* delayed allocation bloc=
ks has been allocated */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_de_remove_spa=
ce(inode, map->m_lblk,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0map->m_len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret < 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D=
 ret;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 up_write((&EXT4_I(inode)->i_data_sem));
>> =A0 =A0 =A0 if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
>> @@ -1630,6 +1648,12 @@ static int ext4_da_get_block_prep(struct inod=
e *inode, sector_t iblock,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* not enough space to r=
eserve */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
>>
>> + =A0 =A0 =A0 =A0 =A0 =A0 down_write((&EXT4_I(inode)->i_data_sem));
>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_de_add_space(inode, map.m_lbl=
k, map.m_len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 up_write((&EXT4_I(inode)->i_data_sem));
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
>> +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 map_bh(bh, inode->i_sb, invalid_block);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_buffer_new(bh);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_buffer_delay(bh);
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 247fcdd..a248551 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -49,6 +49,7 @@
>> =A0#include "xattr.h"
>> =A0#include "acl.h"
>> =A0#include "mballoc.h"
>> +#include "ext4_extents.h"
>>
>> =A0#define CREATE_TRACE_POINTS
>> =A0#include <trace/events/ext4.h>
>> @@ -967,6 +968,7 @@ void ext4_clear_inode(struct inode *inode)
>> =A0 =A0 =A0 end_writeback(inode);
>> =A0 =A0 =A0 dquot_drop(inode);
>> =A0 =A0 =A0 ext4_discard_preallocations(inode);
>> + =A0 =A0 ext4_de_remove_space(inode, 0, EXT_MAX_BLOCKS);
>> =A0 =A0 =A0 if (EXT4_I(inode)->jinode) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_journal_release_jbd_inode(EXT4_JOUR=
NAL(inode),
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0EXT4_I(inode)->jinode);
>> @@ -4976,9 +4978,14 @@ static int __init ext4_init_fs(void)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 init_waitqueue_head(&ext4__ioend_wq[i]);
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 err =3D ext4_init_pageio();
>> + =A0 =A0 err =3D ext4_init_de();
>> =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
>> +
>> + =A0 =A0 err =3D ext4_init_pageio();
>> + =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out8;
>> +
>> =A0 =A0 =A0 err =3D ext4_init_system_zone();
>> =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out7;
>> @@ -5030,6 +5037,9 @@ out6:
>> =A0 =A0 =A0 ext4_exit_system_zone();
>> =A0out7:
>> =A0 =A0 =A0 ext4_exit_pageio();
>> +out8:
>> + =A0 =A0 ext4_exit_de();
>> +
>> =A0 =A0 =A0 return err;
>> =A0}
>>
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
