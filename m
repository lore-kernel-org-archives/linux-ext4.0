From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 1/8 bigalloc] ext4: get blocks from ext4_ext_get_actual_len
Date: Thu, 3 Nov 2011 16:50:04 +0800
Message-ID: <CAGBYx2bc-ZeP5Kk8mrokbWFTYp6T1N_68DhyWsUdqf=ReYhY0A@mail.gmail.com>
References: <1320144817-16397-1-git-send-email-hao.bigrat@gmail.com>
	<1320144817-16397-2-git-send-email-hao.bigrat@gmail.com>
	<3CF57267-8DFB-4AFE-94AA-48036AC80C19@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Robin Dong <hao.bigrat@gmail.com>, linux-ext4@vger.kernel.org,
	Robin Dong <sanbai@taobao.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55038 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab1KCIuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Nov 2011 04:50:04 -0400
Received: by mail-qw0-f46.google.com with SMTP id j40so831585qab.19
        for <linux-ext4@vger.kernel.org>; Thu, 03 Nov 2011 01:50:04 -0700 (PDT)
In-Reply-To: <3CF57267-8DFB-4AFE-94AA-48036AC80C19@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 3, 2011 at 2:29 AM, Andreas Dilger <adilger@dilger.ca> wrot=
e:
> On 2011-11-01, at 4:53 AM, Robin Dong wrote:
>> From: Robin Dong <sanbai@taobao.com>
>>
>> Since ee_len's unit change to cluster, it need to transform from clu=
sters
>> to blocks when use ext4_ext_get_actual_len.
>
> Robin,
> thanks for working on and submitting these patches so quickly.
>
>> struct ext4_extent {
>> =A0 =A0 =A0 __le32 =A0ee_block; =A0 =A0 =A0 /* first logical block e=
xtent covers */
>> - =A0 =A0 __le16 =A0ee_len; =A0 =A0 =A0 =A0 /* number of blocks cove=
red by extent */
>> + =A0 =A0 __le16 =A0ee_len; =A0 =A0 =A0 =A0 /* number of clusters co=
vered by extent */
>
> It would make sense that ee_block should also be changed to be measur=
ed
> in units of clusters instead of blocks, since there is no value to
> using extents with cluster size if they are not also cluster aligned.
>
> I think this would also simplify some of the code.
Actually, after these patches are applied, both logical block and
physical block are all cluster sized.  So I have a suggestion that we
can simply tell users that ext4 can use large size block rather than
cluster.

Yongqiang.

>
>> static int ext4_valid_extent(struct inode *inode, struct ext4_extent=
 *ext)
>> {
>> + =A0 =A0 struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
>
> Why allocate "*sbi" on the stack in all of these functions for a
> single use? =A0This provides no benefit, but can increase the stack
> usage considerably due to repeated allocations.
>
>> =A0 =A0 =A0 ext4_fsblk_t block =3D ext4_ext_pblock(ext);
>> + =A0 =A0 int len =3D EXT4_C2B(sbi, ext4_ext_get_actual_len(ext));
>
> It probably makes more sense to pass "sb" or "sbi" as a parameter to
> ext4_ext_get_actual_len() and then have it return the proper length
> in blocks (i.e. call EXT4_C2B() internally), which will simplify all
> of the callers and avoid potential bugs if some code does not use it.
>
>> @@ -1523,7 +1534,7 @@ ext4_can_extents_be_merged(struct inode *inode=
, struct ext4_extent *ex1,
>> =A0 =A0 =A0 ext1_ee_len =3D ext4_ext_get_actual_len(ex1);
>> =A0 =A0 =A0 ext2_ee_len =3D ext4_ext_get_actual_len(ex2);
>>
>> - =A0 =A0 if (le32_to_cpu(ex1->ee_block) + ext1_ee_len !=3D
>> + =A0 =A0 if (le32_to_cpu(ex1->ee_block) + EXT4_C2B(sbi, ext1_ee_len=
) !=3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le32_to_cpu(ex2->ee_bloc=
k))
>
> If both ee_len and ee_block are in the same units (blocks or clusters=
),
> then there is no need to convert units for this function at all.
>
>
> Cheers, Andreas
>
>
>
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
