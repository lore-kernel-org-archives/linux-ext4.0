From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v2 2/3] ext4:Add two functions splitting an extent.
Date: Fri, 13 May 2011 10:25:25 +0800
Message-ID: <BANLkTi=1vtGBea0aLZXxy9+oKtZ7Og_NUQ@mail.gmail.com>
References: <1304388301-9452-1-git-send-email-xiaoqiangnk@gmail.com>
	<1304388301-9452-3-git-send-email-xiaoqiangnk@gmail.com>
	<1305235906.9708.81.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48627 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab1EMCZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 May 2011 22:25:26 -0400
Received: by vxi39 with SMTP id 39so1561510vxi.19
        for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 19:25:25 -0700 (PDT)
In-Reply-To: <1305235906.9708.81.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 13, 2011 at 5:31 AM, Mingming Cao <cmm@us.ibm.com> wrote:
> On Mon, 2011-05-02 at 19:05 -0700, Yongqiang Yang wrote:
>> v0 -> v1:
>> =A0 =A0-- coding style
>> =A0 =A0-- try to merge extents in zeroout case too.
>>
>> 1] Add a function named ext4_split_extent_at() which splits an exten=
t
>> =A0 =A0into two extents at given logical block.
>>
>> 2] Add a function called ext4_split_extent() which splits an extent
>> =A0 =A0into three extents.
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> Tested-by: Allison Henderson <achender@linux.vnet.ibm.com>
>> ---
>> =A0fs/ext4/extents.c | =A0187 ++++++++++++++++++++++++++++++++++++++=
+++++++++++++++
>> =A01 files changed, 187 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 11f30d2..db1d67c 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2554,6 +2554,193 @@ static int ext4_ext_zeroout(struct inode *in=
ode, struct ext4_extent *ex)
>> =A0 =A0 =A0 return ret;
>> =A0}
>>
>> +/*
>> + * used by extent splitting.
>> + */
>> +#define EXT4_EXT_MAY_ZEROOUT 0x1 =A0/* safe to zeroout if split fai=
ls \
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 due to ENOSPC */
>> +#define EXT4_EXT_MARK_UNINIT1 =A0 =A0 =A0 =A00x2 =A0/* mark first h=
alf uninitialized */
>> +#define EXT4_EXT_MARK_UNINIT2 =A0 =A0 =A0 =A00x4 =A0/* mark second =
half uninitialized */
>> +
>> +/*
>> + * ext4_split_extent_at() splits an extent at given block.
>> + *
>> + * @handle: the journal handle
>> + * @inode: the file inode
>> + * @path: the path to the extent
>> + * @split: the logical block where the extent is splitted.
>> + * @split_flags: indicates if the extent could be zeroout if split =
fails, and
>> + * =A0 =A0 =A0 =A0 =A0 =A0the states(init or uninit) of new extents=
=2E
>> + * @flags: flags used to insert new extent to extent tree.
>> + *
>> + *
>> + * Splits extent [a, b] into two extents [a, @split) and [@split, b=
], states
>> + * of which are deterimined by split_flag.
>> + *
>> + * There are two cases:
>> + * =A0a> the extent are splitted into two extent.
>> + * =A0b> split is not needed, and just mark the extent.
>> + *
>> + * return 0 on success.
>> + */
>> +static int ext4_split_extent_at(handle_t *handle,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct inode *i=
node,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct ext4_ext=
_path *path,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_lblk_t spl=
it,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int split_flag,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int flags)
>> +{
>> + =A0 =A0 ext4_fsblk_t newblock;
>> + =A0 =A0 ext4_lblk_t ee_block;
>> + =A0 =A0 struct ext4_extent *ex, newex, orig_ex;
>> + =A0 =A0 struct ext4_extent *ex2 =3D NULL;
>> + =A0 =A0 unsigned int ee_len, depth;
>> + =A0 =A0 int err =3D 0;
>> +
>> + =A0 =A0 ext_debug("ext4_split_extents_at: inode %lu, logical"
>> + =A0 =A0 =A0 =A0 =A0 =A0 "block %llu\n", inode->i_ino, (unsigned lo=
ng long)split);
>> +
>> + =A0 =A0 ext4_ext_show_leaf(inode, path);
>> +
>> + =A0 =A0 depth =3D ext_depth(inode);
>> + =A0 =A0 ex =3D path[depth].p_ext;
>> + =A0 =A0 ee_block =3D le32_to_cpu(ex->ee_block);
>> + =A0 =A0 ee_len =3D ext4_ext_get_actual_len(ex);
>> + =A0 =A0 newblock =3D split - ee_block + ext4_ext_pblock(ex);
>> +
>> + =A0 =A0 BUG_ON(split < ee_block || split >=3D (ee_block + ee_len))=
;
>> +
>> + =A0 =A0 err =3D ext4_ext_get_access(handle, inode, path + depth);
>> + =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> +
>> + =A0 =A0 if (split =3D=3D ee_block) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* case b: block @split is the block tha=
t the extent begins with
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* then we just change the state of the =
extent, and splitting
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* is not needed.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (split_flag & EXT4_EXT_MARK_UNINIT2)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialize=
d(ex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_initialized(=
ex);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!(flags & EXT4_GET_BLOCKS_PRE_IO))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_try_to_merge(inod=
e, path, ex);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_dirty(handle, inode, path=
 + depth);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 /* case a */
>> + =A0 =A0 memcpy(&orig_ex, ex, sizeof(orig_ex));
>> + =A0 =A0 ex->ee_len =3D cpu_to_le16(split - ee_block);
>> + =A0 =A0 if (split_flag & EXT4_EXT_MARK_UNINIT1)
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex);
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* path may lead to new leaf, not to original leaf any m=
ore
>> + =A0 =A0 =A0* after ext4_ext_insert_extent() returns,
>> + =A0 =A0 =A0*/
>> + =A0 =A0 err =3D ext4_ext_dirty(handle, inode, path + depth);
>> + =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> +
>> + =A0 =A0 ex2 =3D &newex;
>> + =A0 =A0 ex2->ee_block =3D cpu_to_le32(split);
>> + =A0 =A0 ex2->ee_len =A0 =3D cpu_to_le16(ee_len - (split - ee_block=
));
>> + =A0 =A0 ext4_ext_store_pblock(ex2, newblock);
>> + =A0 =A0 if (split_flag & EXT4_EXT_MARK_UNINIT2)
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex2);
>> +
>> + =A0 =A0 err =3D ext4_ext_insert_extent(handle, inode, path, &newex=
, flags);
>> + =A0 =A0 if (err =3D=3D -ENOSPC && (EXT4_EXT_MAY_ZEROOUT & split_fl=
ag)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_zeroout(inode, &orig_ex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* update the extent length and mark as in=
itialized */
>> + =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =3D cpu_to_le32(ee_len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_try_to_merge(inode, path, ex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_dirty(handle, inode, path=
 + depth);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 } else if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> +
>> +out:
>> + =A0 =A0 ext4_ext_show_leaf(inode, path);
>> + =A0 =A0 return err;
>> +
>> +fix_extent_len:
>> + =A0 =A0 ex->ee_len =3D orig_ex.ee_len;
>> + =A0 =A0 ext4_ext_dirty(handle, inode, path + depth);
>> + =A0 =A0 return err;
>> +}
>> +
>> +/*
>> + * ext4_split_extents() splits an extent and mark extent which is c=
overed
>> + * by @map as split_flags indicates
>> + *
>> + * It may result in splitting the extent into multiple extents (upt=
o three)
>> + * There are three possibilities:
>> + * =A0 a> There is no split required
>> + * =A0 b> Splits in two extents: Split is happening at either end o=
f the extent
>> + * =A0 c> Splits in three extents: Somone is splitting in middle of=
 the extent
>> + *
>> + */
>> +static int ext4_split_extent(handle_t *handle,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct inode *=
inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4_ex=
t_path *path,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4_ma=
p_blocks *map,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int split_flag=
,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int flags)
>> +{
>> + =A0 =A0 ext4_lblk_t ee_block;
>> + =A0 =A0 struct ext4_extent *ex;
>> + =A0 =A0 unsigned int ee_len, depth;
>> + =A0 =A0 int err =3D 0;
>> + =A0 =A0 int uninitialized;
>> + =A0 =A0 int split_flag1, flags1;
>> +
>> + =A0 =A0 depth =3D ext_depth(inode);
>> + =A0 =A0 ex =3D path[depth].p_ext;
>> + =A0 =A0 ee_block =3D le32_to_cpu(ex->ee_block);
>> + =A0 =A0 ee_len =3D ext4_ext_get_actual_len(ex);
>> + =A0 =A0 uninitialized =3D ext4_ext_is_uninitialized(ex);
>> +
>> + =A0 =A0 if (map->m_lblk + map->m_len < ee_block + ee_len) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 split_flag1 =3D split_flag & EXT4_EXT_MAY_=
ZEROOUT ?
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_EXT_MAY_Z=
EROOUT : 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 flags1 =3D flags | EXT4_GET_BLOCKS_PRE_IO;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (uninitialized)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_flag1 |=3D EXT4_EXT_=
MARK_UNINIT1 |
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0EXT4_EXT_MARK_UNINIT2;
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_split_extent_at(handle, inode=
, path,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map->m_lbl=
k + map->m_len, split_flag1, flags1);
>> + =A0 =A0 }
>> +
Thank you for looking into the patch.

=46irst, I think I need to explain split_flag added in the patch.  Ther=
e
are three flags in split_flag1.

1.EXT4_EXT_MAY_ZEROOUT means whole extent can be zeroouted instead of
splitting when splitting fails due to ENOSPACE;

2.EXT4_EXT_MARK_UNINIT1 indicates that the 1st part extent should be
marked uninitialized, otherwise initialized.

3.EXT4_EXT_MARK_UNINIT2 is similar to EXT4_EXT_MARK_UNINIT1, only
difference is that it has effect on the 2nd extent.
>
> Hmm, I could not see the zeroout extent gets marked as initialized he=
re.
> Nothing wrong to expose the wrong data, but certainly we are not take
> advantage of zero out, =A0Perhaps I missed something?

Here the extent [ee_block, ee_block + ee_len) is split into two
extents [ee_block, map->m_lblk + map->m_len) and [map->m_lblk +
map->m_len, ee_block + ee_len), which are marked same as ex.
>
> It would be nice to add some comments to describe the difference of
> split_flag1, flags1, flags:-) Thanks.
>
> Also, I think we miss error handling here. What if the first split
> failed and return error here? we still proceed to to do next split? I
> think we should go to the err exit, isnt?
Yes, error handling is missed.
>
>
>> + =A0 =A0 ext4_ext_drop_refs(path);
>> + =A0 =A0 path =3D ext4_ext_find_extent(inode, map->m_lblk, path);
>> + =A0 =A0 if (IS_ERR(path))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(path);
>> +
>> + =A0 =A0 if (map->m_lblk >=3D ee_block) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 split_flag1 =3D split_flag & EXT4_EXT_MAY_=
ZEROOUT ?
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_EXT_MAY_Z=
EROOUT : 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (uninitialized)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_flag1 |=3D EXT4_EXT_=
MARK_UNINIT1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (split_flag & EXT4_EXT_MARK_UNINIT2)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_flag1 |=3D EXT4_EXT_=
MARK_UNINIT2;
Up to now, zeroout part will be marked initialized.
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_split_extent_at(handle, inode=
, path,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map->m_lbl=
k, split_flag1, flags);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }

>> +
>> + =A0 =A0 ext4_ext_show_leaf(inode, path);
>> +out:
>> + =A0 =A0 return err ? err : map->m_len;
>> +}
>> +
>> =A0#define EXT4_EXT_ZERO_LEN 7
>> =A0/*
>> =A0 * This function is called by ext4_ext_map_blocks() if someone tr=
ies to write
>
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
