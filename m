From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH RFC 1/3] ext4:Add a function merging extent right and left.
Date: Fri, 15 Apr 2011 09:12:13 +0800
Message-ID: <BANLkTindru2SnxLLFwb7bMxnkuhwP9MH2g@mail.gmail.com>
References: <1302759651-21222-1-git-send-email-xiaoqiangnk@gmail.com>
	<1302759651-21222-2-git-send-email-xiaoqiangnk@gmail.com>
	<1302807787.3408.25.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:47357 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab1DOBOQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2011 21:14:16 -0400
Received: by pxi2 with SMTP id 2so1234068pxi.10
        for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2011 18:14:16 -0700 (PDT)
In-Reply-To: <1302807787.3408.25.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 15, 2011 at 3:03 AM, Mingming Cao <cmm@us.ibm.com> wrote:
> On Wed, 2011-04-13 at 22:40 -0700, Yongqiang Yang wrote:
>> 1] Rename ext4_ext_try_to_merge() to ext4_ext_try_to_merge_right().
>>
>> 2] Add a new function ext4_ext_try_to_merge() which tries to merge
>> =A0 =A0an extent both left and right.
>>
>> 3] Use the new function in ext4_ext_convert_unwritten_endio() and
>> =A0 =A0ext4_ext_insert_extent().
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext4/extents.c | =A0 65 ++++++++++++++++++++++++++++----------=
--------------
>> =A01 files changed, 35 insertions(+), 30 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index dd2cb50..11f30d2 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -1563,7 +1563,7 @@ ext4_can_extents_be_merged(struct inode *inode=
, struct ext4_extent *ex1,
>> =A0 * Returns 0 if the extents (ex and ex+1) were _not_ merged and r=
eturns
>> =A0 * 1 if they got merged.
>> =A0 */
>> -static int ext4_ext_try_to_merge(struct inode *inode,
>> +static int ext4_ext_try_to_merge_right(struct inode *inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struc=
t ext4_ext_path *path,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struc=
t ext4_extent *ex)
>> =A0{
>> @@ -1603,6 +1603,31 @@ static int ext4_ext_try_to_merge(struct inode=
 *inode,
>> =A0}
>>
>> =A0/*
>> + * This function tries to merge the @ex extent to neighbours in the=
 tree.
>> + * return 1 if merge left else 0.
>> + */
>> +static int ext4_ext_try_to_merge(struct inode *inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct=
 ext4_ext_path *path,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct=
 ext4_extent *ex) {
>> + =A0 =A0 struct ext4_extent_header *eh;
>> + =A0 =A0 unsigned int depth;
>> + =A0 =A0 int merge_done =3D 0;
>> + =A0 =A0 int ret =3D 0;
>> +
>> + =A0 =A0 depth =3D ext_depth(inode);
>> + =A0 =A0 BUG_ON(path[depth].p_hdr =3D=3D NULL);
>> + =A0 =A0 eh =3D path[depth].p_hdr;
>> +
>> + =A0 =A0 if (ex > EXT_FIRST_EXTENT(eh))
>> + =A0 =A0 =A0 =A0 =A0 =A0 merge_done =3D ext4_ext_try_to_merge_right=
(inode, path, ex - 1);
>> +
>> + =A0 =A0 if (!merge_done)
>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_ext_try_to_merge_right(inode,=
 path, ex);
>> +
>
> Is there any reason not to merge right after merge left? The old code
> does both, I think.
What does merge left do?  Actually it does as merge right, it merge
ex-1 to right until no more merges can be done.  So if merge to right
happens then, ex,ex+1 has been tried to merge also.

>
>> + =A0 =A0 return ret;
>> +}
>> +
>> +/*
>> =A0 * check if a portion of the "newext" extent overlaps with an
>> =A0 * existing extent.
>> =A0 *
>> @@ -3039,6 +3064,7 @@ fix_extent_len:
>> =A0 =A0 =A0 ext4_ext_dirty(handle, inode, path + depth);
>> =A0 =A0 =A0 return err;
>> =A0}
>> +
>> =A0static int ext4_convert_unwritten_extents_endio(handle_t *handle,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 struct inode *inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 struct ext4_ext_path *path)
>> @@ -3047,46 +3073,25 @@ static int ext4_convert_unwritten_extents_en=
dio(handle_t *handle,
>> =A0 =A0 =A0 struct ext4_extent_header *eh;
>> =A0 =A0 =A0 int depth;
>> =A0 =A0 =A0 int err =3D 0;
>> - =A0 =A0 int ret =3D 0;
>>
>> =A0 =A0 =A0 depth =3D ext_depth(inode);
>> =A0 =A0 =A0 eh =3D path[depth].p_hdr;
>> =A0 =A0 =A0 ex =3D path[depth].p_ext;
>>
>> + =A0 =A0 ext_debug("ext4_convert_unwritten_extents_endio: inode %lu=
, logical"
>> + =A0 =A0 =A0 =A0 =A0 =A0 "block %llu, max_blocks %u\n", inode->i_in=
o,
>> + =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)le32_to_cpu(ex->ee_blo=
ck),
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_get_actual_len(ex));
>> +
>> =A0 =A0 =A0 err =3D ext4_ext_get_access(handle, inode, path + depth)=
;
>> =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 /* first mark the extent as initialized */
>> =A0 =A0 =A0 ext4_ext_mark_initialized(ex);
>>
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* We have to see if it can be merged with the extent
>> - =A0 =A0 =A0* on the left.
>> - =A0 =A0 =A0*/
>> - =A0 =A0 if (ex > EXT_FIRST_EXTENT(eh)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* To merge left, pass "ex - 1" to try_t=
o_merge(),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* since it merges towards right _only_.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_ext_try_to_merge(inode, path,=
 ex - 1);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_correct_i=
ndexes(handle, inode, path);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 depth =3D ext_depth(inode)=
;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex--;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 }
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* Try to Merge towards right.
>> - =A0 =A0 =A0*/
>> - =A0 =A0 ret =3D ext4_ext_try_to_merge(inode, path, ex);
>> - =A0 =A0 if (ret) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_correct_indexes(handle, i=
node, path);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> - =A0 =A0 =A0 =A0 =A0 =A0 depth =3D ext_depth(inode);
>> - =A0 =A0 }
>> + =A0 =A0 /* correct indexes is nt needed becasue borders are not ch=
anged */
>> + =A0 =A0 ext4_ext_try_to_merge(inode, path, ex);
>> +
>
> Ah, so you discovered an issue -- currently ext4 can't merge across t=
he
> index block borders. that's a pity. This might need to fix up,
Yes, currently borders are changed only in one case that storing an
extent to an empty leaf.

I think the patch which enable merging across index block should be
independent on these patches.


> especially with split is going to be heavily used in punch hole,
> snapshots, direct IO handling holes.
What does direct IO here refer to?  It seems I am missing something.

These patches involves ext4_ext_convrt_to_initialized() in buffer
write case, and split_unwritten_extents() and
convert_to_initialized_endio() in direct IO case.

>
>
>> =A0 =A0 =A0 /* Mark modified extent as dirty */
>> =A0 =A0 =A0 err =3D ext4_ext_dirty(handle, inode, path + depth);
>> =A0out:
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
