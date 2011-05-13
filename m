From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v2 3/3] ext4:Reimplement convert and split_unwritten.
Date: Fri, 13 May 2011 10:31:44 +0800
Message-ID: <BANLkTinA-6tuZVoc6qrS-LVmgE5HKbhnog@mail.gmail.com>
References: <1304388301-9452-1-git-send-email-xiaoqiangnk@gmail.com>
	<1304388301-9452-4-git-send-email-xiaoqiangnk@gmail.com>
	<1305235594.9708.75.camel@mingming-laptop>
	<BANLkTikwXkofQwWZX037XAZNt8x_WA=zGg@mail.gmail.com>
	<1305253114.9708.89.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: achender@linux.vnet.ibm.com, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33569 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab1EMCbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 May 2011 22:31:46 -0400
Received: by vxi39 with SMTP id 39so1563545vxi.19
        for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 19:31:45 -0700 (PDT)
In-Reply-To: <1305253114.9708.89.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 13, 2011 at 10:18 AM, Mingming Cao <cmm@us.ibm.com> wrote:
> On Fri, 2011-05-13 at 10:06 +0800, Yongqiang Yang wrote:
>> On Fri, May 13, 2011 at 5:26 AM, Mingming Cao <cmm@us.ibm.com> wrote=
:
>> > On Mon, 2011-05-02 at 19:05 -0700, Yongqiang Yang wrote:
>> >> v0->v1:
>> >> =A0 -- ext4_ext_convert_initialized() zeroout whole extent when t=
he extent's
>> >> =A0 =A0 =A0length is less than 14.
>> >>
>> >> convert and split unwritten are reimplemented based on ext4_split=
_extent()
>> >> added in last patch.
>> >>
>> >> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> >> Tested-by: Allison Henderson <achender@linux.vnet.ibm.com>
>> >> ---
>> >> =A0fs/ext4/extents.c | =A0480 ++++++++---------------------------=
------------------
>> >> =A01 files changed, 72 insertions(+), 408 deletions(-)
>> >>
>> >> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> >> index db1d67c..9e7c7b3 100644
>> >> --- a/fs/ext4/extents.c
>> >> +++ b/fs/ext4/extents.c
>> >> @@ -2757,17 +2757,13 @@ static int ext4_ext_convert_to_initialize=
d(handle_t *handle,
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0struct ext4_map_blocks *map,
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0struct ext4_ext_path *path)
>> >> =A0{
>> >> - =A0 =A0 struct ext4_extent *ex, newex, orig_ex;
>> >> - =A0 =A0 struct ext4_extent *ex1 =3D NULL;
>> >> - =A0 =A0 struct ext4_extent *ex2 =3D NULL;
>> >> - =A0 =A0 struct ext4_extent *ex3 =3D NULL;
>> >> - =A0 =A0 struct ext4_extent_header *eh;
>> >> + =A0 =A0 struct ext4_map_blocks split_map;
>> >> + =A0 =A0 struct ext4_extent zero_ex;
>> >> + =A0 =A0 struct ext4_extent *ex;
>> >> =A0 =A0 =A0 ext4_lblk_t ee_block, eof_block;
>> >> =A0 =A0 =A0 unsigned int allocated, ee_len, depth;
>> >> - =A0 =A0 ext4_fsblk_t newblock;
>> >> =A0 =A0 =A0 int err =3D 0;
>> >> - =A0 =A0 int ret =3D 0;
>> >> - =A0 =A0 int may_zeroout;
>> >> + =A0 =A0 int split_flag =3D 0;
>> >>
>> >> =A0 =A0 =A0 ext_debug("ext4_ext_convert_to_initialized: inode %lu=
, logical"
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 "block %llu, max_blocks %u\n", inode-=
>i_ino,
>> >> @@ -2779,280 +2775,87 @@ static int ext4_ext_convert_to_initializ=
ed(handle_t *handle,
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 eof_block =3D map->m_lblk + map->m_le=
n;
>> >>
>> >> =A0 =A0 =A0 depth =3D ext_depth(inode);
>> >> - =A0 =A0 eh =3D path[depth].p_hdr;
>> >> =A0 =A0 =A0 ex =3D path[depth].p_ext;
>> >> =A0 =A0 =A0 ee_block =3D le32_to_cpu(ex->ee_block);
>> >> =A0 =A0 =A0 ee_len =3D ext4_ext_get_actual_len(ex);
>> >> =A0 =A0 =A0 allocated =3D ee_len - (map->m_lblk - ee_block);
>> >> - =A0 =A0 newblock =3D map->m_lblk - ee_block + ext4_ext_pblock(e=
x);
>> >> -
>> >> - =A0 =A0 ex2 =3D ex;
>> >> - =A0 =A0 orig_ex.ee_block =3D ex->ee_block;
>> >> - =A0 =A0 orig_ex.ee_len =A0 =3D cpu_to_le16(ee_len);
>> >> - =A0 =A0 ext4_ext_store_pblock(&orig_ex, ext4_ext_pblock(ex));
>> >>
>> >> + =A0 =A0 WARN_ON(map->m_lblk < ee_block);
>> >> =A0 =A0 =A0 /*
>> >> =A0 =A0 =A0 =A0* It is safe to convert extent to initialized via =
explicit
>> >> =A0 =A0 =A0 =A0* zeroout only if extent is fully insde i_size or =
new_size.
>> >> =A0 =A0 =A0 =A0*/
>> >> - =A0 =A0 may_zeroout =3D ee_block + ee_len <=3D eof_block;
>> >> + =A0 =A0 split_flag |=3D ee_block + ee_len <=3D eof_block ? EXT4=
_EXT_MAY_ZEROOUT : 0;
>> >>
>> >> - =A0 =A0 err =3D ext4_ext_get_access(handle, inode, path + depth=
);
>> >> - =A0 =A0 if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> >> =A0 =A0 =A0 /* If extent has less than 2*EXT4_EXT_ZERO_LEN zerout=
 directly */
>> >> - =A0 =A0 if (ee_len <=3D 2*EXT4_EXT_ZERO_LEN && may_zeroout) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zeroout(inode, &ori=
g_ex);
>> >> + =A0 =A0 if (ee_len <=3D 2*EXT4_EXT_ZERO_LEN &&
>> >> + =A0 =A0 =A0 =A0 (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_zeroout(inode, ex);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 /* update the extent length and mark as=
 initialized */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_ex.ee_block;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D orig_ex.ee_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex, ext4_ext_pblo=
ck(&orig_ex));
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_dirty(handle, inode, path + de=
pth);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 /* zeroed the full extent */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> >> - =A0 =A0 }
>> >> -
>> >> - =A0 =A0 /* ex1: ee_block to map->m_lblk - 1 : uninitialized */
>> >> - =A0 =A0 if (map->m_lblk > ee_block) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex1 =3D ex;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex1->ee_len =3D cpu_to_le16(map->m_lblk=
 - ee_block);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex1);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D &newex;
>> >> - =A0 =A0 }
>> >> - =A0 =A0 /*
>> >> - =A0 =A0 =A0* for sanity, update the length of the ex2 extent be=
fore
>> >> - =A0 =A0 =A0* we insert ex3, if ex1 is NULL. This is to avoid te=
mporary
>> >> - =A0 =A0 =A0* overlap of blocks.
>> >> - =A0 =A0 =A0*/
>> >> - =A0 =A0 if (!ex1 && allocated > map->m_len)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex2->ee_len =3D cpu_to_le16(map->m_len)=
;
>> >> - =A0 =A0 /* ex3: to ee_block + ee_len : uninitialised */
>> >> - =A0 =A0 if (allocated > map->m_len) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 unsigned int newdepth;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 /* If extent has less than EXT4_EXT_ZER=
O_LEN zerout directly */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (allocated <=3D EXT4_EXT_ZERO_LEN &&=
 may_zeroout) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* map->m_lblk =3D=3D=
 ee_block is handled by the zerouout
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* at the beginning.
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Mark first half un=
initialized.
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Mark second half i=
nitialized and zero out the
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* initialized extent
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_e=
x.ee_block;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D cpu_=
to_le16(ee_len - allocated);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitial=
ized(ex);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(e=
x, ext4_ext_pblock(&orig_ex));
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_dirty(handle, =
inode, path + depth);
>> >> -
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex3 =3D &newex;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex3->ee_block =3D cpu_t=
o_le32(map->m_lblk);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(e=
x3, newblock);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex3->ee_len =3D cpu_to_=
le16(allocated);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_insert=
_extent(handle, inode, path,
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex3, 0);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err =3D=3D -ENOSPC)=
 {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D=
 =A0ext4_ext_zeroout(inode, &orig_ex);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err=
)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto fix_extent_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_=
block =3D orig_ex.ee_block;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_=
len =A0 =3D orig_ex.ee_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ex=
t_store_pblock(ex,
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ext4_ext_pblock(&orig_ex));
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ex=
t_dirty(handle, inode, path + depth);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* bloc=
ks available from map->m_lblk */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
allocated;
>> >> -
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fi=
x_extent_len;
>> >> -
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We need to zero ou=
t the second half because
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* an fallocate reque=
st can update file size and
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* converting the sec=
ond half to initialized extent
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* implies that we ca=
n leak some junk data to user
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* space.
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zer=
oout(inode, ex3);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We=
 should actually mark the
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* se=
cond half as uninit and return error
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* In=
sert would have changed the extent
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 depth =3D=
 ext_depth(inode);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ex=
t_drop_refs(path);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path =3D=
 ext4_ext_find_extent(inode, map->m_lblk,
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_=
ERR(path)) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 err =3D PTR_ERR(path);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 return err;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* get =
the second half extent details */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex =3D =
path[depth].p_ext;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D=
 ext4_ext_get_access(handle, inode,
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path + depth);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err=
)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 return err;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ex=
t_mark_uninitialized(ex);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ex=
t_dirty(handle, inode, path + depth);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
err;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> -
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* zeroed the second ha=
lf */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex3 =3D &newex;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex3->ee_block =3D cpu_to_le32(map->m_lb=
lk + map->m_len);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex3, newblock + m=
ap->m_len);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex3->ee_len =3D cpu_to_le16(allocated -=
 map->m_len);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex3);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_insert_extent(handle, =
inode, path, ex3, 0);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (err =3D=3D -ENOSPC && may_zeroout) =
{
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zer=
oout(inode, &orig_ex);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fi=
x_extent_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* update the extent le=
ngth and mark as initialized */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_e=
x.ee_block;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D orig=
_ex.ee_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(e=
x, ext4_ext_pblock(&orig_ex));
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_dirty(handle, =
inode, path + depth);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* zeroed the full exte=
nt */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* blocks available fro=
m map->m_lblk */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> >> -
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 } else if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* The depth, and hence eh & ex might=
 change
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* as part of the insert above.
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 newdepth =3D ext_depth(inode);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* update the extent length after suc=
cessful insert of the
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* split extent
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ee_len -=3D ext4_ext_get_actual_len(ex3=
);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 orig_ex.ee_len =3D cpu_to_le16(ee_len);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 may_zeroout =3D ee_block + ee_len <=3D =
eof_block;
>> >> -
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 depth =3D newdepth;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_drop_refs(path);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 path =3D ext4_ext_find_extent(inode, ma=
p->m_lblk, path);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(path)) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D PTR_ERR(path);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 eh =3D path[depth].p_hdr;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex =3D path[depth].p_ext;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (ex2 !=3D &newex)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D ex;
>> >>
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_get_access(handle, i=
node, path + depth);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> >> -
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 allocated =3D map->m_len;
>> >> -
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 /* If extent has less than EXT4_EXT_ZER=
O_LEN and we are trying
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* to insert a extent in the middle z=
erout directly
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* otherwise give the extent a chance=
 to merge to left
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (le16_to_cpu(orig_ex.ee_len) <=3D EX=
T4_EXT_ZERO_LEN &&
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map->m_lblk !=3D ee_blo=
ck && may_zeroout) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zer=
oout(inode, &orig_ex);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fi=
x_extent_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* update the extent le=
ngth and mark as initialized */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_e=
x.ee_block;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D orig=
_ex.ee_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(e=
x, ext4_ext_pblock(&orig_ex));
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_dirty(handle, =
inode, path + depth);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* zero out the first h=
alf */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* blocks available fro=
m map->m_lblk */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> - =A0 =A0 }
>> >> - =A0 =A0 /*
>> >> - =A0 =A0 =A0* If there was a change of depth as part of the
>> >> - =A0 =A0 =A0* insertion of ex3 above, we need to update the leng=
th
>> >> - =A0 =A0 =A0* of the ex1 extent again here
>> >> - =A0 =A0 =A0*/
>> >> - =A0 =A0 if (ex1 && ex1 !=3D ex) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex1 =3D ex;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex1->ee_len =3D cpu_to_le16(map->m_lblk=
 - ee_block);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex1);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D &newex;
>> >> - =A0 =A0 }
>> >> - =A0 =A0 /* ex2: map->m_lblk to map->m_lblk + maxblocks-1 : init=
ialised */
>> >> - =A0 =A0 ex2->ee_block =3D cpu_to_le32(map->m_lblk);
>> >> - =A0 =A0 ext4_ext_store_pblock(ex2, newblock);
>> >> - =A0 =A0 ex2->ee_len =3D cpu_to_le16(allocated);
>> >> - =A0 =A0 if (ex2 !=3D ex)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 goto insert;
>> >> - =A0 =A0 /*
>> >> - =A0 =A0 =A0* New (initialized) extent starts from the first blo=
ck
>> >> - =A0 =A0 =A0* in the current extent. i.e., ex2 =3D=3D ex
>> >> - =A0 =A0 =A0* We have to see if it can be merged with the extent
>> >> - =A0 =A0 =A0* on the left.
>> >> - =A0 =A0 =A0*/
>> >> - =A0 =A0 if (ex2 > EXT_FIRST_EXTENT(eh)) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* To merge left, pass "ex2 - 1" to t=
ry_to_merge(),
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* since it merges towards right _onl=
y_.
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_ext_try_to_merge(inode, pa=
th, ex2 - 1);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_correc=
t_indexes(handle, inode, path);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 depth =3D ext_depth(ino=
de);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex2--;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_initialized(ex);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_try_to_merge(inode, path, ex);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_dirty(handle, inode, p=
ath + depth);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> >> =A0 =A0 =A0 }
>> >> +
>> >> =A0 =A0 =A0 /*
>> >> - =A0 =A0 =A0* Try to Merge towards right. This might be required
>> >> - =A0 =A0 =A0* only when the whole extent is being written to.
>> >> - =A0 =A0 =A0* i.e. ex2 =3D=3D ex and ex3 =3D=3D NULL.
>> >> + =A0 =A0 =A0* four cases:
>> >> + =A0 =A0 =A0* 1. split the extent into three extents.
>> >> + =A0 =A0 =A0* 2. split the extent into two extents, zeroout the =
first half.
>> >> + =A0 =A0 =A0* 3. split the extent into two extents, zeroout the =
second half.
>> >> + =A0 =A0 =A0* 4. split the extent into two extents with out zero=
out.
>> >> =A0 =A0 =A0 =A0*/
>> >> - =A0 =A0 if (!ex3) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_ext_try_to_merge(inode, pa=
th, ex2);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_correc=
t_indexes(handle, inode, path);
>> >> + =A0 =A0 split_map.m_lblk =3D map->m_lblk;
>> >> + =A0 =A0 split_map.m_len =3D map->m_len;
>> >> +
>> >> + =A0 =A0 if (allocated > map->m_len) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (allocated <=3D EXT4_EXT_ZERO_LEN &&
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (EXT4_EXT_MAY_ZEROOUT & split_f=
lag)) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* case 3 */
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_block =3D
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0cpu_to_le32(map->m_lblk + map->m_len);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_len =3D cpu_=
to_le16(allocated - map->m_len);
>> > Hmm, the original code zero out the entire [map->m_lblk, allocated=
],
>> > where here we only zero out a portion of it. it doesnt match the s=
plit
>> > len below also.
>> Yeah, I just zero out a portion of it which is not the requested. =A0=
I
>> think the requested part will have non-zero data.
>
> The requested part is going to be written with data, but since the
> entire [map->m_lblk, allocated] is a relatively small range(<7 blocks=
),
> the cost of zero out this small range is pretty much the same as zero
> out a portion of it. The saving is, we dont have to the split and
> convert the request part from uninitialized to initialized when the
> overwritten data reach to disk.
Yeah, this patch just zeros a portion of it and [map->m_lblk,
allocated]  are converted to initialized.

BTW: I think zeroout can be optimized by zeroing data in pagecache
instead zeroout in disk directly.  What's your opinion?  It is worth
to do or not?
>
> Mingming
>
>> >
>> >
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(&=
zero_ex,
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ex=
t_pblock(ex) + map->m_lblk - ee_block);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_zeroou=
t(inode, &zero_ex);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto =
out;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_map.m_lblk =3D ma=
p->m_lblk;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_map.m_len =3D all=
ocated;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 } else if ((map->m_lblk - ee_block + ma=
p->m_len <
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_EXT_ZERO_LE=
N) &&
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(EXT4_EXT_MAY_ZE=
ROOUT & split_flag)) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* case 2 */
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (map->m_lblk !=3D ee=
_block) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex=
=2Eee_block =3D ex->ee_block;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex=
=2Eee_len =3D cpu_to_le16(map->m_lblk -
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ee_block);
>> > similar to above, the original code zero out the entire [ex->ee_bl=
ock,
>> > map->m_lblk - ee_block + map->m_len], where here we only zero out =
a
>> > portion of it. same to the mismatch of the split len also.
>> Similar to above. =A0Just a optimization.
>> >
>> >
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ex=
t_store_pblock(&zero_ex,
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_pblock(ex));
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D=
 ext4_ext_zeroout(inode, &zero_ex);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err=
)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto out;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> +
>> >> =A0- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0allocated =3D map->m_=
lblk - ee_block + map->m_len;
>> >> +
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_map.m_lblk =3D ee=
_block;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_map.m_len =3D =A0=
map->m_lblk - ee_block + map->m_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0allocated =3D m=
ap->m_len;
>> >
>> > I am also puzzled whether the zeroed-out extent get marked as
>> > initialized, as done in original patch. The whole point of zero ou=
t is
>> > to avoid frequent split of the unitizlized extent if the extent is
>> > short. I will take a closer look at the previous patch.
>> >
>> > Another issue, upon success, "allocated" will return from this fun=
ction.
>> > But here allocated is the zero out length that start from ee_block=
, not
>> > the length from map->m_lblk. this is wrong, the caller
>> > ext4_ext_map_blocks expecting the length of mapped blocks from
>> > map->m_lblk. =A0We now return more mapped blocks than what really =
done. =A0I
>> > suspect the fsx error come from this bug.
>> Yeah. it is a bug.
>>
>> Hi Allison,
>>
>> Could you test with modification above? =A0Here is a bug. I will als=
o test it.
>>
>> Thank you.
>> >
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> >
>> >
>> >> =A0 =A0 =A0 }
>> >> - =A0 =A0 /* Mark modified extent as dirty */
>> >> - =A0 =A0 err =3D ext4_ext_dirty(handle, inode, path + depth);
>> >> - =A0 =A0 goto out;
>> >> -insert:
>> >> - =A0 =A0 err =3D ext4_ext_insert_extent(handle, inode, path, &ne=
wex, 0);
>> >> - =A0 =A0 if (err =3D=3D -ENOSPC && may_zeroout) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zeroout(inode, &ori=
g_ex);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 /* update the extent length and mark as=
 initialized */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_ex.ee_block;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D orig_ex.ee_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex, ext4_ext_pblo=
ck(&orig_ex));
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_dirty(handle, inode, path + de=
pth);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 /* zero out the first half */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> >> - =A0 =A0 } else if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> >> +
>> >> + =A0 =A0 allocated =3D ext4_split_extent(handle, inode, path,
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&split_map, split_flag, 0);
>> >> + =A0 =A0 if (allocated < 0)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D allocated;
>> >> +
>> >> =A0out:
>> >> - =A0 =A0 ext4_ext_show_leaf(inode, path);
>> >> =A0 =A0 =A0 return err ? err : allocated;
>> >> -
>> >> -fix_extent_len:
>> >> - =A0 =A0 ex->ee_block =3D orig_ex.ee_block;
>> >> - =A0 =A0 ex->ee_len =A0 =3D orig_ex.ee_len;
>> >> - =A0 =A0 ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
>> >> - =A0 =A0 ext4_ext_mark_uninitialized(ex);
>> >> - =A0 =A0 ext4_ext_dirty(handle, inode, path + depth);
>> >> - =A0 =A0 return err;
>> >> =A0}
>> >>
>> >> =A0/*
>> >> @@ -3083,15 +2886,11 @@ static int ext4_split_unwritten_extents(h=
andle_t *handle,
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct ext4_ext_path *path,
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 int flags)
>> >> =A0{
>> >> - =A0 =A0 struct ext4_extent *ex, newex, orig_ex;
>> >> - =A0 =A0 struct ext4_extent *ex1 =3D NULL;
>> >> - =A0 =A0 struct ext4_extent *ex2 =3D NULL;
>> >> - =A0 =A0 struct ext4_extent *ex3 =3D NULL;
>> >> - =A0 =A0 ext4_lblk_t ee_block, eof_block;
>> >> - =A0 =A0 unsigned int allocated, ee_len, depth;
>> >> - =A0 =A0 ext4_fsblk_t newblock;
>> >> - =A0 =A0 int err =3D 0;
>> >> - =A0 =A0 int may_zeroout;
>> >> + =A0 =A0 ext4_lblk_t eof_block;
>> >> + =A0 =A0 ext4_lblk_t ee_block;
>> >> + =A0 =A0 struct ext4_extent *ex;
>> >> + =A0 =A0 unsigned int ee_len;
>> >> + =A0 =A0 int split_flag =3D 0, depth;
>> >>
>> >> =A0 =A0 =A0 ext_debug("ext4_split_unwritten_extents: inode %lu, l=
ogical"
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 "block %llu, max_blocks %u\n", inode-=
>i_ino,
>> >> @@ -3101,155 +2900,20 @@ static int ext4_split_unwritten_extents(=
handle_t *handle,
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_sb->s_blocksize_bits;
>> >> =A0 =A0 =A0 if (eof_block < map->m_lblk + map->m_len)
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 eof_block =3D map->m_lblk + map->m_le=
n;
>> >> -
>> >> - =A0 =A0 depth =3D ext_depth(inode);
>> >> - =A0 =A0 ex =3D path[depth].p_ext;
>> >> - =A0 =A0 ee_block =3D le32_to_cpu(ex->ee_block);
>> >> - =A0 =A0 ee_len =3D ext4_ext_get_actual_len(ex);
>> >> - =A0 =A0 allocated =3D ee_len - (map->m_lblk - ee_block);
>> >> - =A0 =A0 newblock =3D map->m_lblk - ee_block + ext4_ext_pblock(e=
x);
>> >> -
>> >> - =A0 =A0 ex2 =3D ex;
>> >> - =A0 =A0 orig_ex.ee_block =3D ex->ee_block;
>> >> - =A0 =A0 orig_ex.ee_len =A0 =3D cpu_to_le16(ee_len);
>> >> - =A0 =A0 ext4_ext_store_pblock(&orig_ex, ext4_ext_pblock(ex));
>> >> -
>> >> =A0 =A0 =A0 /*
>> >> =A0 =A0 =A0 =A0* It is safe to convert extent to initialized via =
explicit
>> >> =A0 =A0 =A0 =A0* zeroout only if extent is fully insde i_size or =
new_size.
>> >> =A0 =A0 =A0 =A0*/
>> >> - =A0 =A0 may_zeroout =3D ee_block + ee_len <=3D eof_block;
>> >> -
>> >> - =A0 =A0 /*
>> >> - =A0 =A0 =A0* If the uninitialized extent begins at the same log=
ical
>> >> - =A0 =A0 =A0* block where the write begins, and the write comple=
tely
>> >> - =A0 =A0 =A0* covers the extent, then we don't need to split it.
>> >> - =A0 =A0 =A0*/
>> >> - =A0 =A0 if ((map->m_lblk =3D=3D ee_block) && (allocated <=3D ma=
p->m_len))
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> >> -
>> >> - =A0 =A0 err =3D ext4_ext_get_access(handle, inode, path + depth=
);
>> >> - =A0 =A0 if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> >> - =A0 =A0 /* ex1: ee_block to map->m_lblk - 1 : uninitialized */
>> >> - =A0 =A0 if (map->m_lblk > ee_block) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex1 =3D ex;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex1->ee_len =3D cpu_to_le16(map->m_lblk=
 - ee_block);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex1);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D &newex;
>> >> - =A0 =A0 }
>> >> - =A0 =A0 /*
>> >> - =A0 =A0 =A0* for sanity, update the length of the ex2 extent be=
fore
>> >> - =A0 =A0 =A0* we insert ex3, if ex1 is NULL. This is to avoid te=
mporary
>> >> - =A0 =A0 =A0* overlap of blocks.
>> >> - =A0 =A0 =A0*/
>> >> - =A0 =A0 if (!ex1 && allocated > map->m_len)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex2->ee_len =3D cpu_to_le16(map->m_len)=
;
>> >> - =A0 =A0 /* ex3: to ee_block + ee_len : uninitialised */
>> >> - =A0 =A0 if (allocated > map->m_len) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 unsigned int newdepth;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex3 =3D &newex;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex3->ee_block =3D cpu_to_le32(map->m_lb=
lk + map->m_len);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex3, newblock + m=
ap->m_len);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex3->ee_len =3D cpu_to_le16(allocated -=
 map->m_len);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex3);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_insert_extent(handle, =
inode, path, ex3, flags);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (err =3D=3D -ENOSPC && may_zeroout) =
{
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zer=
oout(inode, &orig_ex);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fi=
x_extent_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* update the extent le=
ngth and mark as initialized */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_e=
x.ee_block;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D orig=
_ex.ee_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(e=
x, ext4_ext_pblock(&orig_ex));
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_dirty(handle, =
inode, path + depth);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* zeroed the full exte=
nt */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* blocks available fro=
m map->m_lblk */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> >> -
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 } else if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* The depth, and hence eh & ex might=
 change
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* as part of the insert above.
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 newdepth =3D ext_depth(inode);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* update the extent length after suc=
cessful insert of the
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* split extent
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ee_len -=3D ext4_ext_get_actual_len(ex3=
);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 orig_ex.ee_len =3D cpu_to_le16(ee_len);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 may_zeroout =3D ee_block + ee_len <=3D =
eof_block;
>> >> -
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 depth =3D newdepth;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_drop_refs(path);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 path =3D ext4_ext_find_extent(inode, ma=
p->m_lblk, path);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(path)) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D PTR_ERR(path);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex =3D path[depth].p_ext;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (ex2 !=3D &newex)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D ex;
>> >> + =A0 =A0 depth =3D ext_depth(inode);
>> >> + =A0 =A0 ex =3D path[depth].p_ext;
>> >> + =A0 =A0 ee_block =3D le32_to_cpu(ex->ee_block);
>> >> + =A0 =A0 ee_len =3D ext4_ext_get_actual_len(ex);
>> >>
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_get_access(handle, ino=
de, path + depth);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> >> + =A0 =A0 split_flag |=3D ee_block + ee_len <=3D eof_block ? EXT4=
_EXT_MAY_ZEROOUT : 0;
>> >> + =A0 =A0 split_flag |=3D EXT4_EXT_MARK_UNINIT2;
>> >>
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 allocated =3D map->m_len;
>> >> - =A0 =A0 }
>> >> - =A0 =A0 /*
>> >> - =A0 =A0 =A0* If there was a change of depth as part of the
>> >> - =A0 =A0 =A0* insertion of ex3 above, we need to update the leng=
th
>> >> - =A0 =A0 =A0* of the ex1 extent again here
>> >> - =A0 =A0 =A0*/
>> >> - =A0 =A0 if (ex1 && ex1 !=3D ex) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex1 =3D ex;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex1->ee_len =3D cpu_to_le16(map->m_lblk=
 - ee_block);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex1);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D &newex;
>> >> - =A0 =A0 }
>> >> - =A0 =A0 /*
>> >> - =A0 =A0 =A0* ex2: map->m_lblk to map->m_lblk + map->m_len-1 : t=
o be written
>> >> - =A0 =A0 =A0* using direct I/O, uninitialised still.
>> >> - =A0 =A0 =A0*/
>> >> - =A0 =A0 ex2->ee_block =3D cpu_to_le32(map->m_lblk);
>> >> - =A0 =A0 ext4_ext_store_pblock(ex2, newblock);
>> >> - =A0 =A0 ex2->ee_len =3D cpu_to_le16(allocated);
>> >> - =A0 =A0 ext4_ext_mark_uninitialized(ex2);
>> >> - =A0 =A0 if (ex2 !=3D ex)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 goto insert;
>> >> - =A0 =A0 /* Mark modified extent as dirty */
>> >> - =A0 =A0 err =3D ext4_ext_dirty(handle, inode, path + depth);
>> >> - =A0 =A0 ext_debug("out here\n");
>> >> - =A0 =A0 goto out;
>> >> -insert:
>> >> - =A0 =A0 err =3D ext4_ext_insert_extent(handle, inode, path, &ne=
wex, flags);
>> >> - =A0 =A0 if (err =3D=3D -ENOSPC && may_zeroout) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zeroout(inode, &ori=
g_ex);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 /* update the extent length and mark as=
 initialized */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_block =3D orig_ex.ee_block;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =A0 =3D orig_ex.ee_len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex, ext4_ext_pblo=
ck(&orig_ex));
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_dirty(handle, inode, path + de=
pth);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 /* zero out the first half */
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> >> - =A0 =A0 } else if (err)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 goto fix_extent_len;
>> >> -out:
>> >> - =A0 =A0 ext4_ext_show_leaf(inode, path);
>> >> - =A0 =A0 return err ? err : allocated;
>> >> -
>> >> -fix_extent_len:
>> >> - =A0 =A0 ex->ee_block =3D orig_ex.ee_block;
>> >> - =A0 =A0 ex->ee_len =A0 =3D orig_ex.ee_len;
>> >> - =A0 =A0 ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
>> >> - =A0 =A0 ext4_ext_mark_uninitialized(ex);
>> >> - =A0 =A0 ext4_ext_dirty(handle, inode, path + depth);
>> >> - =A0 =A0 return err;
>> >> + =A0 =A0 flags |=3D EXT4_GET_BLOCKS_PRE_IO;
>> >> + =A0 =A0 return ext4_split_extent(handle, inode, path, map, spli=
t_flag, flags);
>> >> =A0}
>> >>
>> >> =A0static int ext4_convert_unwritten_extents_endio(handle_t *hand=
le,
>> >
>> >
>> >
>>
>>
>>
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
