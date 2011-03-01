From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [Ext4 punch hole 1/5] Ext4 Punch Hole Support: Convert Blocks to
 Uninit Exts
Date: Tue, 1 Mar 2011 21:22:02 +0800
Message-ID: <AANLkTi=q8KbCsNc2Cef9q0kY7p3kkt_57f3NuZr+9vzK@mail.gmail.com>
References: <4D6C6318.2010105@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35249 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1CANWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2011 08:22:02 -0500
Received: by mail-iy0-f174.google.com with SMTP id 26so3876690iyb.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 Mar 2011 05:22:02 -0800 (PST)
In-Reply-To: <4D6C6318.2010105@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 1, 2011 at 11:08 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> Hi All!
>
> This is the patch series for ext4 punch hole that I have been working=
 on.
> There is still a little more debugging that I would like to do with i=
t,
> but I've had some requests to see the patch, so I'm sending it out a =
bit
> early. =A0Any feed back is appreciated. =A0Thx!
>
> This first patch adds a function to convert a range of blocks
> to an uninitialized extent. =A0This function will
> be used to first convert the blocks to extents before
> punching them out.
>
> This function also adds a routine to split an extent at
> a given block. =A0This routine is used when a range of
> blocks to be converted is only partially contained in
> an extent.
>
> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> ---
> :100644 100644 7516fb9... ab2e42e... M =A0fs/ext4/extents.c
> =A0fs/ext4/extents.c | =A0185 +++++++++++++++++++++++++++++++++++++++=
++++++++++++++
> =A01 files changed, 185 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7516fb9..ab2e42e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2169,6 +2169,105 @@ static int ext4_remove_blocks(handle_t *handl=
e, struct inode *inode,
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +/*
> + * ext4_split_extents() Splits a given extent at the block "split"
> + * @handle: The journal handle
> + * @inode: The file inode
> + * @split: The block where the extent will be split
> + * @path: The path to the extent
> + * @flags: flags used to insert the new extent
> + */
> +static int ext4_split_extents(handle_t *handle,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct inode *inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ext4_lblk_t split,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct ext4_ext_path *path,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 int flags)
> +{
> + =A0 =A0 =A0 struct ext4_extent *ex, newex, orig_ex, *i_ex;
> + =A0 =A0 =A0 struct ext4_extent *ex1 =3D NULL;
> + =A0 =A0 =A0 struct ext4_extent *ex2 =3D NULL;
> + =A0 =A0 =A0 struct ext4_extent_header *eh;
> + =A0 =A0 =A0 ext4_lblk_t ee_block;
> + =A0 =A0 =A0 unsigned int ee_len, depth;
> + =A0 =A0 =A0 ext4_fsblk_t newblock, origblock;
> + =A0 =A0 =A0 int err =3D 0;
> +
> + =A0 =A0 =A0 ext_debug("ext4_split_extent: inode %lu, split %u\n", i=
node->i_ino, split);
> + =A0 =A0 =A0 ext4_ext_show_leaf(inode, path);
> +
> + =A0 =A0 =A0 depth =3D ext_depth(inode);
> + =A0 =A0 =A0 eh =3D path[depth].p_hdr;
> + =A0 =A0 =A0 ex =3D path[depth].p_ext;
> + =A0 =A0 =A0 ee_block =3D le32_to_cpu(ex->ee_block);
> + =A0 =A0 =A0 ee_len =3D ext4_ext_get_actual_len(ex);
> +
> + =A0 =A0 =A0 /* if the block is not actually in the extent, go to ou=
t */
> + =A0 =A0 =A0 if(split > ee_block+ee_len || split < ee_block)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 origblock =3D ee_block + ext4_ext_pblock(ex);
> + =A0 =A0 =A0 newblock =3D split - ee_block + ext4_ext_pblock(ex);
> + =A0 =A0 =A0 ext_debug("The new block is %llu, the orig block is: %l=
lu\n", newblock, origblock);
> +
> + =A0 =A0 =A0 /* save original block in case split fails */
> + =A0 =A0 =A0 orig_ex.ee_block =3D ex->ee_block;
> + =A0 =A0 =A0 orig_ex.ee_len =A0 =3D cpu_to_le16(ee_len);
> + =A0 =A0 =A0 ext4_ext_store_pblock(&orig_ex, ext4_ext_pblock(ex));
> +
> + =A0 =A0 =A0 err =3D ext4_ext_get_access(handle, inode, path + depth=
);
> + =A0 =A0 =A0 if (err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 ex1 =3D ex;
> + =A0 =A0 =A0 ex1->ee_len =3D cpu_to_le16(split-ee_block);
> +
> + =A0 =A0 =A0 ex2 =3D &newex;
> + =A0 =A0 =A0 ex2->ee_len =3D cpu_to_le16(ee_len-(split-ee_block));
> + =A0 =A0 =A0 ex2->ee_block =3D split;
> + =A0 =A0 =A0 ext4_ext_store_pblock(ex2, newblock);
> +
> + =A0 =A0 =A0 if (ex1->ee_block !=3D ex2->ee_block)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto insert;
> +
> + =A0 =A0 =A0 /* Mark modified extent as dirty */
> + =A0 =A0 =A0 err =3D ext4_ext_dirty(handle, inode, path + depth);
> + =A0 =A0 =A0 ext_debug("out here\n");
> + =A0 =A0 =A0 goto out;
> +insert:
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* If this leaf cannot fit in any more extents
> + =A0 =A0 =A0 =A0* insert it into another leaf
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if(EXT_LAST_EXTENT(eh) >=3D =A0EXT_MAX_EXTENT(eh)){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_insert_extent(handle, =
inode, path, &newex, flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* otherwise just scoot all ther other extents down =A0=
*/
> + =A0 =A0 =A0 else{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for(i_ex =3D EXT_LAST_EXTENT(eh); i_ex =
> ex1; i_ex-- ){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(i_ex+1, i_ex, si=
zeof(struct ext4_extent));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ex1+1, ex2, sizeof(struct ext4_e=
xtent));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 eh->eh_entries++;
> + =A0 =A0 =A0 }
> +
> +out:
> + =A0 =A0 =A0 ext4_ext_show_leaf(inode, path);
> + =A0 =A0 =A0 return err;
> +
> +fix_extent_len:
> + =A0 =A0 =A0 ex->ee_block =3D orig_ex.ee_block;
> + =A0 =A0 =A0 ex->ee_len =A0 =3D orig_ex.ee_len;
> + =A0 =A0 =A0 ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
> + =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex);
> + =A0 =A0 =A0 ext4_ext_dirty(handle, inode, path + depth);
path may be changed in ext4_ext_insert_extent(), as well as depth.
> +
> + =A0 =A0 =A0 return err;
> +}
> +
> =A0static int
> =A0ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct ext4_ext_path *path, ext4_lblk_=
t start)
> @@ -3598,6 +3697,92 @@ out_stop:
> =A0 =A0 =A0 =A0ext4_journal_stop(handle);
> =A0}
>
> +/*
> + * ext4_ext_convert_blocks_uninit()
> + * Converts a range of blocks to uninitialized
> + *
> + * @inode: =A0The files inode
> + * @handle: The journal handle
> + * @lblock: The logical block where the conversion will start
> + * @len: =A0 =A0The max number of blocks to convert
> + *
> + * Returns the number of blocks successfully converted
> + */
> +static int ext4_ext_convert_blocks_uninit(struct inode *inode, handl=
e_t *handle, ext4_lblk_t lblock, ext4_lblk_t len){
> +
> + =A0 =A0 =A0 ext4_lblk_t ee_block, iblock;
> + =A0 =A0 =A0 struct ext4_ext_path *path;
> + =A0 =A0 =A0 struct ext4_extent *ex;
> + =A0 =A0 =A0 unsigned int ee_len;
> + =A0 =A0 =A0 int ret, err =3D 0;
> +
> + =A0 =A0 =A0 iblock =3D lblock;
> + =A0 =A0 =A0 while(iblock < lblock+len){
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 path =3D ext4_ext_find_extent(inode, lb=
lock, NULL);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(path =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto next;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_get_access(handle, ino=
de, path);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(err < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto next;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex =3D path->p_ext;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(ex =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto next;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ee_block =3D le32_to_cpu(ex->ee_block);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ee_len =3D ext4_ext_get_actual_len(ex);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If the block is in the middle of t=
he extent,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* split the extent to remove the hea=
d.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Then find the new extent that cont=
ains the block
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(ee_block < iblock){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_split_exte=
nts(handle, inode, iblock, path, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ne=
xt;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path =3D ext4_ext_find_=
extent(inode, iblock, NULL);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(path =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ne=
xt;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex =3D path->p_ext;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(ex =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ne=
xt;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ee_block =3D le32_to_cp=
u(ex->ee_block);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ee_len =3D ext4_ext_get=
_actual_len(ex);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If the extent exceeds len, split the=
 extent to remove the tail */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(ee_len > len){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_split_exte=
nts(handle, inode, lblock+len, path, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ne=
xt;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ee_len =3D ext4_ext_get=
_actual_len(ex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Mark the extent uninitialized */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iblock+=3Dex->ee_len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret+=3Dex->ee_len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> +next:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If the extent for this block cannot =
be found, skip it */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iblock++;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return ret;
> +}
> +
> +
> =A0static void ext4_falloc_update_inode(struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int mo=
de, loff_t new_size, int update_ctime)
> =A0{
> --
> 1.7.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
