From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4:Fix a bug in ext4_ext_fiemap_cb().
Date: Thu, 24 Feb 2011 08:37:08 +0800
Message-ID: <AANLkTikDiNP40x=CXKUYEyObtd+hX09cJ0A3H0_5dOaX@mail.gmail.com>
References: <1298476779-27883-1-git-send-email-xiaoqiangnk@gmail.com>
	<FDE557FB-8511-4CBB-A32D-2E5B82C71E4B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38449 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1BXAhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Feb 2011 19:37:09 -0500
Received: by ewy6 with SMTP id 6so6224ewy.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Feb 2011 16:37:08 -0800 (PST)
In-Reply-To: <FDE557FB-8511-4CBB-A32D-2E5B82C71E4B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 24, 2011 at 7:35 AM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-02-23, at 8:59 AM, Yongqiang Yang wrote:
>> @@ -3788,17 +3788,27 @@ static int ext4_ext_fiemap_cb(struct inode *=
inode,
>> - =A0 =A0 if (newex->ec_start =3D=3D 0) {
>> + =A0 =A0 if (!newex->ec_start) {
>
> (style) the original code is actually correct. =A0ec_start is not a b=
oolean, so comparing it =3D=3D 0 is actually the right thing to do.
>
>> @@ -3807,8 +3817,13 @@ static int ext4_ext_fiemap_cb(struct inode *i=
node, struct ext4_ext_path *path,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!bh)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EXT_CONTINUE;
>>
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* Assume block-size equals page-size. */
>
> This is not a valid assumption.
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_delay(bh)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D FIEMAP_EXTENT=
_DELALLOC;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (page->index > offset) =
{
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 logical =3D=
 =A0((__u64)page->index << PAGE_SHIFT);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 newex->ec_=
block =3D logical >> blksize_bits;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> So, this assumes that the entire unmapped extent is described by the =
first page, but doesn't actually check whether all of the pages exist. =
=A0For the purpose of cp it might be OK, since at worst it means that c=
p will be reading from a hole in the source file. =A0However, I wonder =
if other applications will depend on the allocated extent being more ac=
curate?
>
>> +EXPORT_SYMBOL(find_get_pages);
>
> Eric had also suggested pagevec_lookup_tag(), which is already export=
ed.
Yes, we can use this function.  I will make a new patch.
>
> Cheers, Andreas
>
>
>
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
