From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v2 3/3] ext4:Reimplement convert and split_unwritten.
Date: Fri, 13 May 2011 10:06:09 +0800
Message-ID: <BANLkTikwXkofQwWZX037XAZNt8x_WA=zGg@mail.gmail.com>
References: <1304388301-9452-1-git-send-email-xiaoqiangnk@gmail.com>
	<1304388301-9452-4-git-send-email-xiaoqiangnk@gmail.com>
	<1305235594.9708.75.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Mingming Cao <cmm@us.ibm.com>, achender@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65031 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab1EMCGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 May 2011 22:06:10 -0400
Received: by vxi39 with SMTP id 39so1554989vxi.19
        for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 19:06:09 -0700 (PDT)
In-Reply-To: <1305235594.9708.75.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 13, 2011 at 5:26 AM, Mingming Cao <cmm@us.ibm.com> wrote:
> On Mon, 2011-05-02 at 19:05 -0700, Yongqiang Yang wrote:
>> v0->v1:
>> =A0 -- ext4_ext_convert_initialized() zeroout whole extent when the =
extent's
>> =A0 =A0 =A0length is less than 14.
>>
>> convert and split unwritten are reimplemented based on ext4_split_ex=
tent()
>> added in last patch.
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> Tested-by: Allison Henderson <achender@linux.vnet.ibm.com>
>> ---
>> =A0fs/ext4/extents.c | =A0480 ++++++++------------------------------=
---------------
>> =A01 files changed, 72 insertions(+), 408 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index db1d67c..9e7c7b3 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2757,17 +2757,13 @@ static int ext4_ext_convert_to_initialized(h=
andle_t *handle,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0struct ext4_map_blocks *map,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0struct ext4_ext_path *path)
>> =A0{
>> - =A0 =A0 struct ext4_extent *ex, newex, orig_ex;
>> - =A0 =A0 struct ext4_extent *ex1 =3D NULL;
>> - =A0 =A0 struct ext4_extent *ex2 =3D NULL;
>> - =A0 =A0 struct ext4_extent *ex3 =3D NULL;
>> - =A0 =A0 struct ext4_extent_header *eh;
>> + =A0 =A0 struct ext4_map_blocks split_map;
>> + =A0 =A0 struct ext4_extent zero_ex;
>> + =A0 =A0 struct ext4_extent *ex;
>> =A0 =A0 =A0 ext4_lblk_t ee_block, eof_block;
>> =A0 =A0 =A0 unsigned int allocated, ee_len, depth;
>> - =A0 =A0 ext4_fsblk_t newblock;
>> =A0 =A0 =A0 int err =3D 0;
>> - =A0 =A0 int ret =3D 0;
>> - =A0 =A0 int may_zeroout;
>> + =A0 =A0 int split_flag =3D 0;
>>
>> =A0 =A0 =A0 ext_debug("ext4_ext_convert_to_initialized: inode %lu, l=
ogical"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 "block %llu, max_blocks %u\n", inode->i_=
ino,
>> @@ -2779,280 +2775,87 @@ static int ext4_ext_convert_to_initialized(=
handle_t *handle,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 eof_block =3D map->m_lblk + map->m_len;
>>
>> =A0 =A0 =A0 depth =3D ext_depth(inode);
>> - =A0 =A0 eh =3D path[depth].p_hdr;
>> =A0 =A0 =A0 ex =3D path[depth].p_ext;
>> =A0 =A0 =A0 ee_block =3D le32_to_cpu(ex->ee_block);
>> =A0 =A0 =A0 ee_len =3D ext4_ext_get_actual_len(ex);
>> =A0 =A0 =A0 allocated =3D ee_len - (map->m_lblk - ee_block);
>> - =A0 =A0 newblock =3D map->m_lblk - ee_block + ext4_ext_pblock(ex);
>> -
>> - =A0 =A0 ex2 =3D ex;
>> - =A0 =A0 orig_ex.ee_block =3D ex->ee_block;
>> - =A0 =A0 orig_ex.ee_len =A0 =3D cpu_to_le16(ee_len);
>> - =A0 =A0 ext4_ext_store_pblock(&orig_ex, ext4_ext_pblock(ex));
>>
>> + =A0 =A0 WARN_ON(map->m_lblk < ee_block);
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* It is safe to convert extent to initialized via exp=
licit
>> =A0 =A0 =A0 =A0* zeroout only if extent is fully insde i_size or new=
_size.
>> =A0 =A0 =A0 =A0*/
>> - =A0 =A0 may_zeroout =3D ee_block + ee_len <=3D eof_block;
>> + =A0 =A0 split_flag |=3D ee_block + ee_len <=3D eof_block ? EXT4_EX=
T_MAY_ZEROOUT : 0;
>>
>> - =A0 =A0 err =3D ext4_ext_get_access(handle, inode, path + depth);
>> - =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 /* If extent has less than 2*EXT4_EXT_ZERO_LEN zerout di=
rectly */
>> - =A0 =A0 if (ee_len <=3D 2*EXT4_EXT_ZERO_LEN && may_zeroout) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zeroout(inode, &orig_e=
x);
>> + =A0 =A0 if (ee_len <=3D 2*EXT4_EXT_ZERO_LEN &&
>> + =A0 =A0 =A0 =A0 (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_zeroout(inode, ex);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* update the extent length and mark as in=
itialized */
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_ex.ee_block;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D orig_ex.ee_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex, ext4_ext_pblock(=
&orig_ex));
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_dirty(handle, inode, path + depth=
);
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* zeroed the full extent */
>> - =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 /* ex1: ee_block to map->m_lblk - 1 : uninitialized */
>> - =A0 =A0 if (map->m_lblk > ee_block) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex1 =3D ex;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex1->ee_len =3D cpu_to_le16(map->m_lblk - =
ee_block);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex1);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D &newex;
>> - =A0 =A0 }
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* for sanity, update the length of the ex2 extent befor=
e
>> - =A0 =A0 =A0* we insert ex3, if ex1 is NULL. This is to avoid tempo=
rary
>> - =A0 =A0 =A0* overlap of blocks.
>> - =A0 =A0 =A0*/
>> - =A0 =A0 if (!ex1 && allocated > map->m_len)
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex2->ee_len =3D cpu_to_le16(map->m_len);
>> - =A0 =A0 /* ex3: to ee_block + ee_len : uninitialised */
>> - =A0 =A0 if (allocated > map->m_len) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 unsigned int newdepth;
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* If extent has less than EXT4_EXT_ZERO_L=
EN zerout directly */
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (allocated <=3D EXT4_EXT_ZERO_LEN && ma=
y_zeroout) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* map->m_lblk =3D=3D ee=
_block is handled by the zerouout
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* at the beginning.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Mark first half unini=
tialized.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Mark second half init=
ialized and zero out the
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* initialized extent
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_ex.e=
e_block;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D cpu_to_=
le16(ee_len - allocated);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialize=
d(ex);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex, =
ext4_ext_pblock(&orig_ex));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_dirty(handle, ino=
de, path + depth);
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex3 =3D &newex;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex3->ee_block =3D cpu_to_l=
e32(map->m_lblk);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex3,=
 newblock);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex3->ee_len =3D cpu_to_le1=
6(allocated);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_insert_ex=
tent(handle, inode, path,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex3, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err =3D=3D -ENOSPC) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0=
ext4_ext_zeroout(inode, &orig_ex);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto fix_extent_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_blo=
ck =3D orig_ex.ee_block;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len=
 =A0 =3D orig_ex.ee_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_s=
tore_pblock(ex,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 ext4_ext_pblock(&orig_ex));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_d=
irty(handle, inode, path + depth);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* blocks =
available from map->m_lblk */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return all=
ocated;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_e=
xtent_len;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We need to zero out t=
he second half because
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* an fallocate request =
can update file size and
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* converting the second=
 half to initialized extent
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* implies that we can l=
eak some junk data to user
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* space.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zeroou=
t(inode, ex3);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We sh=
ould actually mark the
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* secon=
d half as uninit and return error
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Inser=
t would have changed the extent
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 depth =3D =
ext_depth(inode);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_d=
rop_refs(path);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path =3D e=
xt4_ext_find_extent(inode, map->m_lblk,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR=
(path)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 err =3D PTR_ERR(path);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 return err;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* get the=
 second half extent details */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex =3D pat=
h[depth].p_ext;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ex=
t4_ext_get_access(handle, inode,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path + depth);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 return err;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_m=
ark_uninitialized(ex);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_d=
irty(handle, inode, path + depth);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err=
;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* zeroed the second half =
*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex3 =3D &newex;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex3->ee_block =3D cpu_to_le32(map->m_lblk =
+ map->m_len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex3, newblock + map-=
>m_len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex3->ee_len =3D cpu_to_le16(allocated - ma=
p->m_len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex3);
>> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_insert_extent(handle, ino=
de, path, ex3, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (err =3D=3D -ENOSPC && may_zeroout) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zeroou=
t(inode, &orig_ex);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_e=
xtent_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* update the extent lengt=
h and mark as initialized */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_ex.e=
e_block;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D orig_ex=
=2Eee_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex, =
ext4_ext_pblock(&orig_ex));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_dirty(handle, ino=
de, path + depth);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* zeroed the full extent =
*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* blocks available from m=
ap->m_lblk */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 } else if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* The depth, and hence eh & ex might ch=
ange
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* as part of the insert above.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 newdepth =3D ext_depth(inode);
>> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* update the extent length after succes=
sful insert of the
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* split extent
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 ee_len -=3D ext4_ext_get_actual_len(ex3);
>> - =A0 =A0 =A0 =A0 =A0 =A0 orig_ex.ee_len =3D cpu_to_le16(ee_len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 may_zeroout =3D ee_block + ee_len <=3D eof=
_block;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 depth =3D newdepth;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_drop_refs(path);
>> - =A0 =A0 =A0 =A0 =A0 =A0 path =3D ext4_ext_find_extent(inode, map->=
m_lblk, path);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(path)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D PTR_ERR(path);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 eh =3D path[depth].p_hdr;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex =3D path[depth].p_ext;
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (ex2 !=3D &newex)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D ex;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_get_access(handle, inod=
e, path + depth);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 allocated =3D map->m_len;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* If extent has less than EXT4_EXT_ZERO_L=
EN and we are trying
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* to insert a extent in the middle zero=
ut directly
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* otherwise give the extent a chance to=
 merge to left
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (le16_to_cpu(orig_ex.ee_len) <=3D EXT4_=
EXT_ZERO_LEN &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map->m_lblk !=3D ee_block =
&& may_zeroout) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zeroou=
t(inode, &orig_ex);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_e=
xtent_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* update the extent lengt=
h and mark as initialized */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_ex.e=
e_block;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D orig_ex=
=2Eee_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex, =
ext4_ext_pblock(&orig_ex));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_dirty(handle, ino=
de, path + depth);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* zero out the first half=
 */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* blocks available from m=
ap->m_lblk */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 }
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* If there was a change of depth as part of the
>> - =A0 =A0 =A0* insertion of ex3 above, we need to update the length
>> - =A0 =A0 =A0* of the ex1 extent again here
>> - =A0 =A0 =A0*/
>> - =A0 =A0 if (ex1 && ex1 !=3D ex) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex1 =3D ex;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex1->ee_len =3D cpu_to_le16(map->m_lblk - =
ee_block);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex1);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D &newex;
>> - =A0 =A0 }
>> - =A0 =A0 /* ex2: map->m_lblk to map->m_lblk + maxblocks-1 : initial=
ised */
>> - =A0 =A0 ex2->ee_block =3D cpu_to_le32(map->m_lblk);
>> - =A0 =A0 ext4_ext_store_pblock(ex2, newblock);
>> - =A0 =A0 ex2->ee_len =3D cpu_to_le16(allocated);
>> - =A0 =A0 if (ex2 !=3D ex)
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto insert;
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* New (initialized) extent starts from the first block
>> - =A0 =A0 =A0* in the current extent. i.e., ex2 =3D=3D ex
>> - =A0 =A0 =A0* We have to see if it can be merged with the extent
>> - =A0 =A0 =A0* on the left.
>> - =A0 =A0 =A0*/
>> - =A0 =A0 if (ex2 > EXT_FIRST_EXTENT(eh)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* To merge left, pass "ex2 - 1" to try_=
to_merge(),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* since it merges towards right _only_.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_ext_try_to_merge(inode, path,=
 ex2 - 1);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_correct_i=
ndexes(handle, inode, path);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 depth =3D ext_depth(inode)=
;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex2--;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_initialized(ex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_try_to_merge(inode, path, ex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_dirty(handle, inode, path=
 + depth);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 }
>> +
>> =A0 =A0 =A0 /*
>> - =A0 =A0 =A0* Try to Merge towards right. This might be required
>> - =A0 =A0 =A0* only when the whole extent is being written to.
>> - =A0 =A0 =A0* i.e. ex2 =3D=3D ex and ex3 =3D=3D NULL.
>> + =A0 =A0 =A0* four cases:
>> + =A0 =A0 =A0* 1. split the extent into three extents.
>> + =A0 =A0 =A0* 2. split the extent into two extents, zeroout the fir=
st half.
>> + =A0 =A0 =A0* 3. split the extent into two extents, zeroout the sec=
ond half.
>> + =A0 =A0 =A0* 4. split the extent into two extents with out zeroout=
=2E
>> =A0 =A0 =A0 =A0*/
>> - =A0 =A0 if (!ex3) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_ext_try_to_merge(inode, path,=
 ex2);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_correct_i=
ndexes(handle, inode, path);
>> + =A0 =A0 split_map.m_lblk =3D map->m_lblk;
>> + =A0 =A0 split_map.m_len =3D map->m_len;
>> +
>> + =A0 =A0 if (allocated > map->m_len) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (allocated <=3D EXT4_EXT_ZERO_LEN &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (EXT4_EXT_MAY_ZEROOUT & split_flag=
)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* case 3 */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_block =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cpu_to_le32(map->m_lblk + map->m_len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_len =3D cpu_to_=
le16(allocated - map->m_len);
> Hmm, the original code zero out the entire [map->m_lblk, allocated],
> where here we only zero out a portion of it. it doesnt match the spli=
t
> len below also.
Yeah, I just zero out a portion of it which is not the requested.  I
think the requested part will have non-zero data.
>
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(&zer=
o_ex,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_p=
block(ex) + map->m_lblk - ee_block);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_zeroout(i=
node, &zero_ex);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_map.m_lblk =3D map->=
m_lblk;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_map.m_len =3D alloca=
ted;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if ((map->m_lblk - ee_block + map->=
m_len <
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_EXT_ZERO_LEN) =
&&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(EXT4_EXT_MAY_ZEROO=
UT & split_flag)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* case 2 */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (map->m_lblk !=3D ee_bl=
ock) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee=
_block =3D ex->ee_block;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee=
_len =3D cpu_to_le16(map->m_lblk -
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ee_block);
> similar to above, the original code zero out the entire [ex->ee_block=
,
> map->m_lblk - ee_block + map->m_len], where here we only zero out a
> portion of it. same to the mismatch of the split len also.
Similar to above.  Just a optimization.
>
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_s=
tore_pblock(&zero_ex,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_pblock(ex));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ex=
t4_ext_zeroout(inode, &zero_ex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto out;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>>  -=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 allocated =3D map->m_lblk =
- ee_block + map->m_len;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_map.m_lblk =3D ee_bl=
ock;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_map.m_len =3D  map->=
m_lblk - ee_block + map->m_len;
+                          allocated =3D map->m_len;
>
> I am also puzzled whether the zeroed-out extent get marked as
> initialized, as done in original patch. The whole point of zero out i=
s
> to avoid frequent split of the unitizlized extent if the extent is
> short. I will take a closer look at the previous patch.
>
> Another issue, upon success, "allocated" will return from this functi=
on.
> But here allocated is the zero out length that start from ee_block, n=
ot
> the length from map->m_lblk. this is wrong, the caller
> ext4_ext_map_blocks expecting the length of mapped blocks from
> map->m_lblk. =A0We now return more mapped blocks than what really don=
e. =A0I
> suspect the fsx error come from this bug.
Yeah. it is a bug.

Hi Allison,

Could you test with modification above?  Here is a bug. I will also tes=
t it.

Thank you.
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
>
>> =A0 =A0 =A0 }
>> - =A0 =A0 /* Mark modified extent as dirty */
>> - =A0 =A0 err =3D ext4_ext_dirty(handle, inode, path + depth);
>> - =A0 =A0 goto out;
>> -insert:
>> - =A0 =A0 err =3D ext4_ext_insert_extent(handle, inode, path, &newex=
, 0);
>> - =A0 =A0 if (err =3D=3D -ENOSPC && may_zeroout) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zeroout(inode, &orig_e=
x);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* update the extent length and mark as in=
itialized */
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_ex.ee_block;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D orig_ex.ee_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex, ext4_ext_pblock(=
&orig_ex));
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_dirty(handle, inode, path + depth=
);
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* zero out the first half */
>> - =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> - =A0 =A0 } else if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> +
>> + =A0 =A0 allocated =3D ext4_split_extent(handle, inode, path,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0&split_map, split_flag, 0);
>> + =A0 =A0 if (allocated < 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D allocated;
>> +
>> =A0out:
>> - =A0 =A0 ext4_ext_show_leaf(inode, path);
>> =A0 =A0 =A0 return err ? err : allocated;
>> -
>> -fix_extent_len:
>> - =A0 =A0 ex->ee_block =3D orig_ex.ee_block;
>> - =A0 =A0 ex->ee_len =A0 =3D orig_ex.ee_len;
>> - =A0 =A0 ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
>> - =A0 =A0 ext4_ext_mark_uninitialized(ex);
>> - =A0 =A0 ext4_ext_dirty(handle, inode, path + depth);
>> - =A0 =A0 return err;
>> =A0}
>>
>> =A0/*
>> @@ -3083,15 +2886,11 @@ static int ext4_split_unwritten_extents(hand=
le_t *handle,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 struct ext4_ext_path *path,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 int flags)
>> =A0{
>> - =A0 =A0 struct ext4_extent *ex, newex, orig_ex;
>> - =A0 =A0 struct ext4_extent *ex1 =3D NULL;
>> - =A0 =A0 struct ext4_extent *ex2 =3D NULL;
>> - =A0 =A0 struct ext4_extent *ex3 =3D NULL;
>> - =A0 =A0 ext4_lblk_t ee_block, eof_block;
>> - =A0 =A0 unsigned int allocated, ee_len, depth;
>> - =A0 =A0 ext4_fsblk_t newblock;
>> - =A0 =A0 int err =3D 0;
>> - =A0 =A0 int may_zeroout;
>> + =A0 =A0 ext4_lblk_t eof_block;
>> + =A0 =A0 ext4_lblk_t ee_block;
>> + =A0 =A0 struct ext4_extent *ex;
>> + =A0 =A0 unsigned int ee_len;
>> + =A0 =A0 int split_flag =3D 0, depth;
>>
>> =A0 =A0 =A0 ext_debug("ext4_split_unwritten_extents: inode %lu, logi=
cal"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 "block %llu, max_blocks %u\n", inode->i_=
ino,
>> @@ -3101,155 +2900,20 @@ static int ext4_split_unwritten_extents(han=
dle_t *handle,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_sb->s_blocksize_bits;
>> =A0 =A0 =A0 if (eof_block < map->m_lblk + map->m_len)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 eof_block =3D map->m_lblk + map->m_len;
>> -
>> - =A0 =A0 depth =3D ext_depth(inode);
>> - =A0 =A0 ex =3D path[depth].p_ext;
>> - =A0 =A0 ee_block =3D le32_to_cpu(ex->ee_block);
>> - =A0 =A0 ee_len =3D ext4_ext_get_actual_len(ex);
>> - =A0 =A0 allocated =3D ee_len - (map->m_lblk - ee_block);
>> - =A0 =A0 newblock =3D map->m_lblk - ee_block + ext4_ext_pblock(ex);
>> -
>> - =A0 =A0 ex2 =3D ex;
>> - =A0 =A0 orig_ex.ee_block =3D ex->ee_block;
>> - =A0 =A0 orig_ex.ee_len =A0 =3D cpu_to_le16(ee_len);
>> - =A0 =A0 ext4_ext_store_pblock(&orig_ex, ext4_ext_pblock(ex));
>> -
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* It is safe to convert extent to initialized via exp=
licit
>> =A0 =A0 =A0 =A0* zeroout only if extent is fully insde i_size or new=
_size.
>> =A0 =A0 =A0 =A0*/
>> - =A0 =A0 may_zeroout =3D ee_block + ee_len <=3D eof_block;
>> -
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* If the uninitialized extent begins at the same logica=
l
>> - =A0 =A0 =A0* block where the write begins, and the write completel=
y
>> - =A0 =A0 =A0* covers the extent, then we don't need to split it.
>> - =A0 =A0 =A0*/
>> - =A0 =A0 if ((map->m_lblk =3D=3D ee_block) && (allocated <=3D map->=
m_len))
>> - =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> -
>> - =A0 =A0 err =3D ext4_ext_get_access(handle, inode, path + depth);
>> - =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> - =A0 =A0 /* ex1: ee_block to map->m_lblk - 1 : uninitialized */
>> - =A0 =A0 if (map->m_lblk > ee_block) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex1 =3D ex;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex1->ee_len =3D cpu_to_le16(map->m_lblk - =
ee_block);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex1);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D &newex;
>> - =A0 =A0 }
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* for sanity, update the length of the ex2 extent befor=
e
>> - =A0 =A0 =A0* we insert ex3, if ex1 is NULL. This is to avoid tempo=
rary
>> - =A0 =A0 =A0* overlap of blocks.
>> - =A0 =A0 =A0*/
>> - =A0 =A0 if (!ex1 && allocated > map->m_len)
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex2->ee_len =3D cpu_to_le16(map->m_len);
>> - =A0 =A0 /* ex3: to ee_block + ee_len : uninitialised */
>> - =A0 =A0 if (allocated > map->m_len) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 unsigned int newdepth;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex3 =3D &newex;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex3->ee_block =3D cpu_to_le32(map->m_lblk =
+ map->m_len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex3, newblock + map-=
>m_len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex3->ee_len =3D cpu_to_le16(allocated - ma=
p->m_len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex3);
>> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_insert_extent(handle, ino=
de, path, ex3, flags);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (err =3D=3D -ENOSPC && may_zeroout) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zeroou=
t(inode, &orig_ex);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_e=
xtent_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* update the extent lengt=
h and mark as initialized */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_ex.e=
e_block;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D orig_ex=
=2Eee_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex, =
ext4_ext_pblock(&orig_ex));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_dirty(handle, ino=
de, path + depth);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* zeroed the full extent =
*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* blocks available from m=
ap->m_lblk */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 } else if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* The depth, and hence eh & ex might ch=
ange
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* as part of the insert above.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 newdepth =3D ext_depth(inode);
>> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* update the extent length after succes=
sful insert of the
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* split extent
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 ee_len -=3D ext4_ext_get_actual_len(ex3);
>> - =A0 =A0 =A0 =A0 =A0 =A0 orig_ex.ee_len =3D cpu_to_le16(ee_len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 may_zeroout =3D ee_block + ee_len <=3D eof=
_block;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 depth =3D newdepth;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_drop_refs(path);
>> - =A0 =A0 =A0 =A0 =A0 =A0 path =3D ext4_ext_find_extent(inode, map->=
m_lblk, path);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(path)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D PTR_ERR(path);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex =3D path[depth].p_ext;
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (ex2 !=3D &newex)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D ex;
>> + =A0 =A0 depth =3D ext_depth(inode);
>> + =A0 =A0 ex =3D path[depth].p_ext;
>> + =A0 =A0 ee_block =3D le32_to_cpu(ex->ee_block);
>> + =A0 =A0 ee_len =3D ext4_ext_get_actual_len(ex);
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_get_access(handle, inode,=
 path + depth);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 split_flag |=3D ee_block + ee_len <=3D eof_block ? EXT4_EX=
T_MAY_ZEROOUT : 0;
>> + =A0 =A0 split_flag |=3D EXT4_EXT_MARK_UNINIT2;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 allocated =3D map->m_len;
>> - =A0 =A0 }
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* If there was a change of depth as part of the
>> - =A0 =A0 =A0* insertion of ex3 above, we need to update the length
>> - =A0 =A0 =A0* of the ex1 extent again here
>> - =A0 =A0 =A0*/
>> - =A0 =A0 if (ex1 && ex1 !=3D ex) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex1 =3D ex;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex1->ee_len =3D cpu_to_le16(map->m_lblk - =
ee_block);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex1);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D &newex;
>> - =A0 =A0 }
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* ex2: map->m_lblk to map->m_lblk + map->m_len-1 : to b=
e written
>> - =A0 =A0 =A0* using direct I/O, uninitialised still.
>> - =A0 =A0 =A0*/
>> - =A0 =A0 ex2->ee_block =3D cpu_to_le32(map->m_lblk);
>> - =A0 =A0 ext4_ext_store_pblock(ex2, newblock);
>> - =A0 =A0 ex2->ee_len =3D cpu_to_le16(allocated);
>> - =A0 =A0 ext4_ext_mark_uninitialized(ex2);
>> - =A0 =A0 if (ex2 !=3D ex)
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto insert;
>> - =A0 =A0 /* Mark modified extent as dirty */
>> - =A0 =A0 err =3D ext4_ext_dirty(handle, inode, path + depth);
>> - =A0 =A0 ext_debug("out here\n");
>> - =A0 =A0 goto out;
>> -insert:
>> - =A0 =A0 err =3D ext4_ext_insert_extent(handle, inode, path, &newex=
, flags);
>> - =A0 =A0 if (err =3D=3D -ENOSPC && may_zeroout) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zeroout(inode, &orig_e=
x);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* update the extent length and mark as in=
itialized */
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_ex.ee_block;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D orig_ex.ee_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex, ext4_ext_pblock(=
&orig_ex));
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_dirty(handle, inode, path + depth=
);
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* zero out the first half */
>> - =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> - =A0 =A0 } else if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> -out:
>> - =A0 =A0 ext4_ext_show_leaf(inode, path);
>> - =A0 =A0 return err ? err : allocated;
>> -
>> -fix_extent_len:
>> - =A0 =A0 ex->ee_block =3D orig_ex.ee_block;
>> - =A0 =A0 ex->ee_len =A0 =3D orig_ex.ee_len;
>> - =A0 =A0 ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
>> - =A0 =A0 ext4_ext_mark_uninitialized(ex);
>> - =A0 =A0 ext4_ext_dirty(handle, inode, path + depth);
>> - =A0 =A0 return err;
>> + =A0 =A0 flags |=3D EXT4_GET_BLOCKS_PRE_IO;
>> + =A0 =A0 return ext4_split_extent(handle, inode, path, map, split_f=
lag, flags);
>> =A0}
>>
>> =A0static int ext4_convert_unwritten_extents_endio(handle_t *handle,
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
