From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: ext4_ext_convert_to_initialized bug found in extended FSX testing
Date: Fri, 13 May 2011 09:52:15 +0800
Message-ID: <BANLkTinFcUCV3nEbY7chgdht_-6ch1Th5Q@mail.gmail.com>
References: <4DC97C32.2020203@linux.vnet.ibm.com>
	<BANLkTi=jjVcy9WQvNfYwPVNw-+t4M5WbFw@mail.gmail.com>
	<1305162935.4102.13.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39586 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759121Ab1EMBwQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 May 2011 21:52:16 -0400
Received: by vws1 with SMTP id 1so1539575vws.19
        for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 18:52:15 -0700 (PDT)
In-Reply-To: <1305162935.4102.13.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 12, 2011 at 9:15 AM, Mingming Cao <cmm@us.ibm.com> wrote:
> On Wed, 2011-05-11 at 09:47 +0800, Yongqiang Yang wrote:
>> On Wed, May 11, 2011 at 1:56 AM, Allison Henderson
>> <achender@linux.vnet.ibm.com> wrote:
>> > Hi All,
>> >
>> > We've been trying to get punch hole through some extended fsx test=
s, and I ran across some other tests that were failing because the test=
 file contained zeros where it shouldn't. =A0I made this fix to the ext=
4_ext_convert_to_initialized
>>
>> What do you mean zeros here?
>> Some useful data is zeroed?
>>
>> and the test has been running smooth for about an hour now.
>> Yongqiang, this one looks like it may have been associated with the
>> split extents clean up patch. =A0Would you mind taking a look at thi=
s
>> fix and giving it your ok if it looks good? =A0Thx!
>> >
>> > Signed-off-by: Allison Henderson <achender@us.ibm.com>
>> > ---
>> > :100644 100644 e363f21... ce69450... M =A0fs/ext4/extents.c
>> > =A0fs/ext4/extents.c | =A0 =A03 ++-
>> > =A01 files changed, 2 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> > index e363f21..ce69450 100644
>> > --- a/fs/ext4/extents.c
>> > +++ b/fs/ext4/extents.c
>> > @@ -2819,7 +2819,8 @@ static int ext4_ext_convert_to_initialized(h=
andle_t *handle,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* case 3 */
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0zero_ex.ee_block =3D
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 cpu_to_le32(map->m_lblk + map->m_len);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_len =3D c=
pu_to_le16(allocated - map->m_len);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_len =3D c=
pu_to_le16(ee_len -
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 allocated - map->m_len);
>> The logic is that we splits [ee_block, ee_block + ee_len) into
>> [ee_block, map->m_blk) that is uninitialized and [map->m_blk, ee_blo=
ck
>> + ee_len) that is initialized. =A0 We need to zero [map->m_lblk +
>> map->m_len, ee_block + ee_len).
>> and [map->m_lblk, map->m_lblk + map->m_len) is zeroed by upper layer
>> because of MAP_NEW flag.
>>
>> Right logic?
>>
>
Hi Mingming,

Sorry for late response.

> Hmm, the logic in case 3 is-- if ex2[map->m_blk, map->m_blk+m_len] an=
d
> ex3 together[map->mblk+m_len+1, map->m_blk+allocated] total length
> (allocated)is < than 7 blocks, then we zero out the entire ex2 and ex=
t3,
> there is no need to do split.
I only zero out ext3 because ext2 is the requested extent so it will
be flushed with data that application writes.  So zeroing ext3 is
enough.
>
> I think zero_ex.ee_len should be "allocated". Look at the original co=
de
> (before the extents splits cleanup patches), it will zero out entire
> [map->mblk, map->m_blk+allocated] and don't do split anymore.
>
>
> something like this, not a patch, but show what I think the right fix=
=2E


>
>
> =A0 =A0 =A0 if (allocated > map->m_len) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (allocated <=3D EXT4_EXT_ZERO_LEN &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (EXT4_EXT_MAY_ZEROOUT & split_fla=
g)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* case 3 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_block =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cpu_to_le32(map->m_lblk + map->m_len);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_len =3D cpu_=
to_le16(allocated - map->m_len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_len =3D cpu_to=
_le16(allocated);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(&ze=
ro_ex,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_=
pblock(ex) + map->m_lblk - ee_block);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_zeroout(=
inode, &zero_ex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto o=
ut;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_map.m_lblk =3D ma=
p->m_lblk;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 split_map.m_len =3D all=
ocated;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_initializ=
ed(ex);
Nope.  ex is initially uninitialized, it is split into two extents
[ee_block, map->m_lblk) and [map->m_lblk, ee_block + ee_len).
the 1st should be uninitialized while the 2nd one should be
initialized and this is
done in ext4_split_extent().
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_try_to_merge(i=
node, path, ex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_dirty(hand=
le, inode, path + depth);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0}
>
>
>
> Mingming
>
>
>>
>> I can not see the error and the meaning of ee_len - allocated - map-=
>m_len.
>>
>> Thanks,
>> Yongqiang.
>>
>>
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_ext_store_pblo=
ck(&zero_ex,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext=
4_ext_pblock(ex) + map->m_lblk - ee_block);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_ext_ze=
roout(inode, &zero_ex);
>> > --
>> > 1.7.1
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
