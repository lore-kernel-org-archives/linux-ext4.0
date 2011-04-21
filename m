From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH RFC 3/3] ext4:Reimplement convert and split_unwritten.
Date: Thu, 21 Apr 2011 17:10:10 +0800
Message-ID: <BANLkTi=Pndb_Fg7Q5XPFvAHowQ0j_6mpQA@mail.gmail.com>
References: <1302759651-21222-1-git-send-email-xiaoqiangnk@gmail.com>
	<1302759651-21222-4-git-send-email-xiaoqiangnk@gmail.com>
	<4DAFEAAB.8040809@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45207 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1DUJKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Apr 2011 05:10:12 -0400
Received: by wya21 with SMTP id 21so1254521wya.19
        for <linux-ext4@vger.kernel.org>; Thu, 21 Apr 2011 02:10:11 -0700 (PDT)
In-Reply-To: <4DAFEAAB.8040809@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 21, 2011 at 4:28 PM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 4/13/2011 10:40 PM, Yongqiang Yang wrote:
>> convert and split unwritten are reimplemented based on ext4_split_ex=
tent()
>> added in last patch.
>>
>> Signed-off-by: Yongqiang Yang<xiaoqiangnk@gmail.com>
>> ---
>> =A0 fs/ext4/extents.c | =A0483 ++++++++-----------------------------=
---------------
>> =A0 1 files changed, 75 insertions(+), 408 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 1756e0f..ee2dda3 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2770,17 +2770,13 @@ static int ext4_ext_convert_to_initialized(h=
andle_t *handle,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0struct ext4_map_blocks *map,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0struct ext4_ext_path *path)
>> =A0 {
>> + =A0 =A0 struct ext4_map_blocks split_map;
>> + =A0 =A0 struct ext4_extent zero_ex;
>> + =A0 =A0 struct ext4_extent *ex;
>> =A0 =A0 =A0 ext4_lblk_t ee_block, eof_block;
>> =A0 =A0 =A0 unsigned int allocated, ee_len, depth;
>> =A0 =A0 =A0 int err =3D 0;
>> + =A0 =A0 int split_flag =3D 0;
>>
>> =A0 =A0 =A0 ext_debug("ext4_ext_convert_to_initialized: inode %lu, l=
ogical"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 "block %llu, max_blocks %u\n", inode->i_=
ino,
>> @@ -2792,280 +2788,90 @@ static int ext4_ext_convert_to_initialized(=
handle_t *handle,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 eof_block =3D map->m_lblk + map->m_len;
>>
>> =A0 =A0 =A0 depth =3D ext_depth(inode);
>> =A0 =A0 =A0 ex =3D path[depth].p_ext;
>> =A0 =A0 =A0 ee_block =3D le32_to_cpu(ex->ee_block);
>> =A0 =A0 =A0 ee_len =3D ext4_ext_get_actual_len(ex);
>> =A0 =A0 =A0 allocated =3D ee_len - (map->m_lblk - ee_block);
>>
>> + =A0 =A0 WARN_ON(map->m_lblk< =A0ee_block);
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* It is safe to convert extent to initialized via exp=
licit
>> =A0 =A0 =A0 =A0* zeroout only if extent is fully insde i_size or new=
_size.
>> =A0 =A0 =A0 =A0*/
>> + =A0 =A0 split_flag |=3D ee_block + ee_len<=3D eof_block ? EXT4_EXT=
_MAY_ZEROOUT : 0;
>>
>> =A0 =A0 =A0 /* If extent has less than 2*EXT4_EXT_ZERO_LEN zerout di=
rectly */
>> + =A0 =A0 if (ee_len<=3D 2*EXT4_EXT_ZERO_LEN&&
>> + =A0 =A0 =A0 =A0 (EXT4_EXT_MAY_ZEROOUT& =A0split_flag)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_block =3D ex->ee_block;
>> + =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_len =3D cpu_to_le16(map->m_lblk=
 - ee_block);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(&zero_ex, ext4_ext_p=
block(ex));
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_zeroout(inode,&zero_ex);
Hi,

Sorry, this is a bug.  We should zero out two extents [ee_block,
map->m_lblk) and [map->m_lblk + map->m_len, ee_block + ee_len).
Original ext4 code zero out whole extent ex.  Could you try to have a
test which zero out whole extent like below.
              err =3D ext4_ext_zeroout(inode,ex);

ext4_ext_zeroout() wait until all zero IOs are finished.  Slowness may
come from two ext4_ext_zeroout()s.

BTW:  we can optimize ext4_ext_zeroout() by zeroing out pages in page
cache and marking the pages dirty.=A0 What's your opinion?

Thank you,
Yongqiang.

> Hi again,
>
> I am working on trying to get the code to pass the fsx stress test. =A0=
If I add this snippet of code here, it seems to fix most of the tests, =
but it is very slow. =A0So this may not be the best solution yet. =A0Bu=
t I thought if updated you with what I found we might be able to come u=
p with a better solution.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if((map->m_lblk + map->m_len) < ee_blo=
ck + ee_len){
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0zero_ex.ee_block =3D m=
ap->m_lblk + map->m_len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0zero_ex.ee_len =3D cpu=
_to_le16(ee_len - (map->m_lblk + map->m_len));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_ext_store_pblock(=
&zero_ex, ext4_ext_pblock(ex)+(map->m_lblk - ee_block)+ map->m_len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_ext_zeroo=
ut(inode, &zero_ex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto o=
ut;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> At the moment, the test fails because a portion of the test file does=
 not get zeroed out when it should. =A0The punch hole code needs to flu=
sh the pages before it punches out any blocks. =A0It uses the filemap_w=
rite_and_wait_range routine, which eventually calls ext4_ext_convert_to=
_initialized. =A0The bug only appears to show up when flushing out the =
middle of an unwritten extent. The two halves on either side are suppos=
ed to get zeroed out or split off, but it looks like one of them was no=
t getting zeroed out. =A0This snippet seems to fix that, but I'm not ye=
t sure why it's so slow.
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_get_access(handle, inod=
e, path + depth);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_initialized(ex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_try_to_merge(inode, path, ex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_dirty(handle, inode, path=
 + depth);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 }
>> +
>> =A0 =A0 =A0 /*
>> + =A0 =A0 =A0* four cases:
>> + =A0 =A0 =A0* 1. split the extent into three extents.
>> + =A0 =A0 =A0* 2. split the extent into two extents, zeroout the fir=
st half.
>> + =A0 =A0 =A0* 3. split the extent into two extents, zeroout the sec=
ond half.
>> + =A0 =A0 =A0* 4. split the extent into two extents with out zeroout=
=2E
>> =A0 =A0 =A0 =A0*/
>> + =A0 =A0 split_map.m_lblk =3D map->m_lblk;
>> + =A0 =A0 split_map.m_len =3D map->m_len;
>> +
>> + =A0 =A0 if (allocated> =A0map->m_len) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (allocated<=3D EXT4_EXT_ZERO_LEN&&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (EXT4_EXT_MAY_ZEROOUT& =A0split_fl=
ag)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* case 3 */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_block =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cpu_to_le32(map->m_lblk + map->m_len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_len =3D cpu_to_=
le16(allocated - map->m_len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(&zer=
o_ex,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_p=
block(ex) + map->m_lblk - ee_block);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_zeroout(i=
node,&zero_ex);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_map.m_lblk =3D map->=
m_lblk;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_map.m_len =3D alloca=
ted;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if ((map->m_lblk - ee_block + map->=
m_len<
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_EXT_ZERO_LEN)&=
&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(EXT4_EXT_MAY_ZEROO=
UT& =A0split_flag)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* case 2 */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (map->m_lblk !=3D ee_bl=
ock) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee=
_block =3D ex->ee_block;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee=
_len =3D cpu_to_le16(map->m_lblk -
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ee_block);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_s=
tore_pblock(&zero_ex,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_pblock(ex));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ex=
t4_ext_zeroout(inode,&zero_ex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto out;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 allocated =3D map->m_lblk =
- ee_block + map->m_len;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_map.m_lblk =3D ee_bl=
ock;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_map.m_len =3D alloca=
ted;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>> +
>> + =A0 =A0 allocated =3D ext4_split_extent(handle, inode, path,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &split_map=
, split_flag, 0);
>> + =A0 =A0 if (allocated< =A00)
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D allocated;
>> +
>> =A0 out:
>> =A0 =A0 =A0 return err ? err : allocated;
>> =A0 }
>>
>> =A0 /*
>> @@ -3096,15 +2902,11 @@ static int ext4_split_unwritten_extents(hand=
le_t *handle,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 struct ext4_ext_path *path,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 int flags)
>> =A0 {
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
>> @@ -3114,155 +2916,20 @@ static int ext4_split_unwritten_extents(han=
dle_t *handle,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_sb->s_blocksize_bits;
>> =A0 =A0 =A0 if (eof_block< =A0map->m_lblk + map->m_len)
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
>> - =A0 =A0 may_zeroout =3D ee_block + ee_len<=3D eof_block;
>> -
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* If the uninitialized extent begins at the same logica=
l
>> - =A0 =A0 =A0* block where the write begins, and the write completel=
y
>> - =A0 =A0 =A0* covers the extent, then we don't need to split it.
>> - =A0 =A0 =A0*/
>> - =A0 =A0 if ((map->m_lblk =3D=3D ee_block)&& =A0(allocated<=3D map-=
>m_len))
>> - =A0 =A0 =A0 =A0 =A0 =A0 return allocated;
>> -
>> - =A0 =A0 err =3D ext4_ext_get_access(handle, inode, path + depth);
>> - =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> - =A0 =A0 /* ex1: ee_block to map->m_lblk - 1 : uninitialized */
>> - =A0 =A0 if (map->m_lblk> =A0ee_block) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex1 =3D ex;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex1->ee_len =3D cpu_to_le16(map->m_lblk - =
ee_block);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex1);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D&newex;
>> - =A0 =A0 }
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* for sanity, update the length of the ex2 extent befor=
e
>> - =A0 =A0 =A0* we insert ex3, if ex1 is NULL. This is to avoid tempo=
rary
>> - =A0 =A0 =A0* overlap of blocks.
>> - =A0 =A0 =A0*/
>> - =A0 =A0 if (!ex1&& =A0allocated> =A0map->m_len)
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex2->ee_len =3D cpu_to_le16(map->m_len);
>> - =A0 =A0 /* ex3: to ee_block + ee_len : uninitialised */
>> - =A0 =A0 if (allocated> =A0map->m_len) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 unsigned int newdepth;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex3 =3D&newex;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex3->ee_block =3D cpu_to_le32(map->m_lblk =
+ map->m_len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(ex3, newblock + map-=
>m_len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex3->ee_len =3D cpu_to_le16(allocated - ma=
p->m_len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex3);
>> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_insert_extent(handle, ino=
de, path, ex3, flags);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (err =3D=3D -ENOSPC&& =A0may_zeroout) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zeroou=
t(inode,&orig_ex);
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
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* The depth, and hence eh& =A0ex might =
change
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
>> - =A0 =A0 =A0 =A0 =A0 =A0 may_zeroout =3D ee_block + ee_len<=3D eof_=
block;
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
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (ex2 !=3D&newex)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D ex;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_get_access(handle, inode,=
 path + depth);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 depth =3D ext_depth(inode);
>> + =A0 =A0 ex =3D path[depth].p_ext;
>> + =A0 =A0 ee_block =3D le32_to_cpu(ex->ee_block);
>> + =A0 =A0 ee_len =3D ext4_ext_get_actual_len(ex);
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 allocated =3D map->m_len;
>> - =A0 =A0 }
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* If there was a change of depth as part of the
>> - =A0 =A0 =A0* insertion of ex3 above, we need to update the length
>> - =A0 =A0 =A0* of the ex1 extent again here
>> - =A0 =A0 =A0*/
>> - =A0 =A0 if (ex1&& =A0ex1 !=3D ex) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex1 =3D ex;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex1->ee_len =3D cpu_to_le16(map->m_lblk - =
ee_block);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex1);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ex2 =3D&newex;
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
>> - =A0 =A0 err =3D ext4_ext_insert_extent(handle, inode, path,&newex,=
 flags);
>> - =A0 =A0 if (err =3D=3D -ENOSPC&& =A0may_zeroout) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D =A0ext4_ext_zeroout(inode,&orig_ex=
);
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
>> + =A0 =A0 split_flag |=3D ee_block + ee_len<=3D eof_block ? EXT4_EXT=
_MAY_ZEROOUT : 0;
>> + =A0 =A0 split_flag |=3D EXT4_EXT_MARK_UNINIT2;
>>
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
>> =A0 }
>>
>> =A0 static int ext4_convert_unwritten_extents_endio(handle_t *handle=
,
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
