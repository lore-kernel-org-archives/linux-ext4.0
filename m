From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH RFC 2/3] ext4:Add two functions splitting an extent.
Date: Thu, 21 Apr 2011 09:18:57 +0800
Message-ID: <BANLkTing0XEdEgoHs3v-gO8e+R42+qZCPg@mail.gmail.com>
References: <1302759651-21222-1-git-send-email-xiaoqiangnk@gmail.com>
	<1302759651-21222-3-git-send-email-xiaoqiangnk@gmail.com>
	<4DAF1635.7070406@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43675 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab1DUBS5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Apr 2011 21:18:57 -0400
Received: by pvg12 with SMTP id 12so646946pvg.19
        for <linux-ext4@vger.kernel.org>; Wed, 20 Apr 2011 18:18:57 -0700 (PDT)
In-Reply-To: <4DAF1635.7070406@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 21, 2011 at 1:21 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 4/13/2011 10:40 PM, Yongqiang Yang wrote:
>> 1] Add a function named ext4_split_extent_at() which splits an exten=
t
>> =A0 =A0 into two extents at given logical block.
>>
>> 2] Add a function called ext4_split_extent() which splits an extent
>> =A0 =A0 into three extents.
>>
>> Signed-off-by: Yongqiang Yang<xiaoqiangnk@gmail.com>
>> ---
>> =A0 fs/ext4/extents.c | =A0200 +++++++++++++++++++++++++++++++++++++=
++++++++++++++++
>> =A0 1 files changed, 200 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 11f30d2..1756e0f 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2554,6 +2554,206 @@ static int ext4_ext_zeroout(struct inode *in=
ode, struct ext4_extent *ex)
>> =A0 =A0 =A0 return ret;
>> =A0 }
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
>> + * =A0a> =A0the extent are splitted into two extent.
>> + * =A0b> =A0split is not needed, and just mark the extent.
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
>> + =A0 =A0 struct ext4_extent_header *eh;
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
>> + =A0 =A0 eh =3D path[depth].p_hdr;
>> + =A0 =A0 ex =3D path[depth].p_ext;
>> + =A0 =A0 ee_block =3D le32_to_cpu(ex->ee_block);
>> + =A0 =A0 ee_len =3D ext4_ext_get_actual_len(ex);
>> + =A0 =A0 newblock =3D split - ee_block + ext4_ext_pblock(ex);
>> +
>> + =A0 =A0 BUG_ON(split< =A0ee_block || split>=3D (ee_block + ee_len)=
);
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (split_flag& =A0EXT4_EXT_MARK_UNINIT2)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialize=
d(ex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_initialized(=
ex);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!(flags& =A0EXT4_GET_BLOCKS_PRE_IO))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_try_to_merge(inod=
e, path, ex);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_dirty(handle, inode, path=
 + depth);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 /* case a */
>> + =A0 =A0 orig_ex.ee_block =3D ex->ee_block;
>> + =A0 =A0 orig_ex.ee_len =A0 =3D ex->ee_len;
>> + =A0 =A0 ext4_ext_store_pblock(&orig_ex, ext4_ext_pblock(ex));
>> +
>> + =A0 =A0 ex->ee_len =3D cpu_to_le16(split - ee_block);
>> + =A0 =A0 if (split_flag& =A0EXT4_EXT_MARK_UNINIT1)
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
>> + =A0 =A0 ex2 =3D&newex;
>> + =A0 =A0 ex2->ee_block =3D cpu_to_le32(split);
>> + =A0 =A0 ex2->ee_len =A0 =3D cpu_to_le16(ee_len - (split - ee_block=
));
>> + =A0 =A0 ext4_ext_store_pblock(ex2, newblock);
>> + =A0 =A0 if (split_flag& =A0EXT4_EXT_MARK_UNINIT2)
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex2);
>> +
>> + =A0 =A0 err =3D ext4_ext_insert_extent(handle, inode, path,&newex,=
 flags);
>> + =A0 =A0 if (err =3D=3D -ENOSPC&& =A0(EXT4_EXT_MAY_ZEROOUT& =A0spli=
t_flag)) {
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_zeroout(inode,&orig_ex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* update the extent length and mark as in=
itialized */
>> + =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_ex.ee_block;
>> + =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D orig_ex.ee_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_initialized(ex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex, ext4_ext_pblock(=
&orig_ex));
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
>> + =A0 =A0 ex->ee_block =3D orig_ex.ee_block;
>> + =A0 =A0 ex->ee_len =A0 =3D orig_ex.ee_len;
>> + =A0 =A0 ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
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
>> + * =A0 a> =A0There is no split required
>> + * =A0 b> =A0Splits in two extents: Split is happening at either en=
d of the extent
>> + * =A0 c> =A0Splits in three extents: Somone is splitting in middle=
 of the extent
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
>> + =A0 =A0 if (map->m_lblk + map->m_len< =A0ee_block + ee_len) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 split_flag1 =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 split_flag1 |=3D split_flag& =A0EXT4_EXT_M=
AY_ZEROOUT ?
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_EXT_MA=
Y_ZEROOUT : 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 flags1 =3D flags;
>> + =A0 =A0 =A0 =A0 =A0 =A0 flags1 |=3D EXT4_GET_BLOCKS_PRE_IO;
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
>> + =A0 =A0 ext4_ext_drop_refs(path);
>> + =A0 =A0 path =3D ext4_ext_find_extent(inode, map->m_lblk, path);
>> + =A0 =A0 if (IS_ERR(path))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(path);
>> +
>> + =A0 =A0 if (map->m_lblk>=3D ee_block) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 split_flag1 =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 split_flag1 |=3D split_flag& =A0EXT4_EXT_M=
AY_ZEROOUT ?
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_EXT_MA=
Y_ZEROOUT : 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (uninitialized)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_flag1 |=3D EXT4_EXT_=
MARK_UNINIT1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (split_flag& =A0EXT4_EXT_MARK_UNINIT2)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_flag1 |=3D EXT4_EXT_=
MARK_UNINIT2;
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
>> =A0 #define EXT4_EXT_ZERO_LEN 7
>> =A0 /*
>> =A0 =A0* This function is called by ext4_ext_map_blocks() if someone=
 tries to write
>
>
> Hi there,
>
> I've been working on trying to get the punch hole patch to work with =
with these new changes, but it looks like some test cases are not passi=
ng at the moment, so I'm trying track down where the issues are. =A0I h=
ad to make some adjustments to this patch to fix one of the test cases.=
 =A0Here is what I did:
>
> ---
> :100644 100644 ee2dda3... c7d763d... M =A0fs/ext4/extents.c
> =A0fs/ext4/extents.c | =A0 =A06 +++---
> =A01 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ee2dda3..c7d763d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2717,12 +2717,12 @@ static int ext4_split_extent(handle_t *handle=
,
> =A0 =A0 =A0 =A0ee_len =3D ext4_ext_get_actual_len(ex);
> =A0 =A0 =A0 =A0uninitialized =3D ext4_ext_is_uninitialized(ex);
>
> + =A0 =A0 =A0 flags1 =3D flags;
> + =A0 =A0 =A0 flags1 |=3D EXT4_GET_BLOCKS_PRE_IO;
Hi, the flag should be passed via parameters,
ext4_convert_to_initialized() uses this function also.  so merge
should be done in this case.

If the patches has other problems needing me to fix, please let me know=
=2E

Thank you,
Yongqiang.

> =A0 =A0 =A0 =A0if (map->m_lblk + map->m_len < ee_block + ee_len) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0split_flag1 =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0split_flag1 |=3D split_flag & EXT4_EXT=
_MAY_ZEROOUT ?
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_EXT_=
MAY_ZEROOUT : 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags1 =3D flags;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags1 |=3D EXT4_GET_BLOCKS_PRE_IO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (uninitialized)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0split_flag1 |=3D EXT4_=
EXT_MARK_UNINIT1 |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 EXT4_EXT_MARK_UNINIT2;
> @@ -2744,7 +2744,7 @@ static int ext4_split_extent(handle_t *handle,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (split_flag & EXT4_EXT_MARK_UNINIT2=
)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0split_flag1 |=3D EXT4_=
EXT_MARK_UNINIT2;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_split_extent_at(handle, i=
node, path,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map->m_=
lblk, split_flag1, flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map->m_=
lblk, split_flag1, flags1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
> --
> 1.7.1
>
>
> Let me know if this change works for you. =A0It looks like the proble=
m was that the extents were getting merged back together because the se=
cond ext4_split_extent_at didnt have the EXT4_GET_BLOCKS_PRE_IO flag, s=
o this should fix it. =A0There are still some other test cases that are=
 showing some odd behavior, so I will keep you posted if I have to make=
 any other changes.
>
> Allison Henderson
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
