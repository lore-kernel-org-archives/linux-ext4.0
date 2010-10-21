From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: fsck get error with the file which is > 2TB in 4k block file system
Date: Thu, 21 Oct 2010 10:04:43 -0700
Message-ID: <AANLkTinGXEWX8JWDjgvtHvjgNPeyTTdxEih3thAr+asx@mail.gmail.com>
References: <AANLkTik6mjHAZG2ePmDyBmb6CRhV8=dD_tTTdhCzykca@mail.gmail.com>
	<4CC056E4.8000208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ck ya <ykwan0201@gmail.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63302 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab0JUREo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Oct 2010 13:04:44 -0400
Received: by pwj3 with SMTP id 3so42424pwj.19
        for <linux-ext4@vger.kernel.org>; Thu, 21 Oct 2010 10:04:44 -0700 (PDT)
In-Reply-To: <4CC056E4.8000208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 21, 2010 at 8:06 AM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> ck ya wrote:
>> I compiled the latest e2fsprogs, and do fsck with -nvf on my ext4 fi=
le system.
>> It showed
>> Inode 18, i_blocks is 17179870744, should be 17179870744. Fix? no
>> The i_blocks is the same.
>>
>> I found ext2fs_inode_i_blocks() has problem. =A0The function check
>> EXT4_FEATURE_RO_COMPAT_HUGE_FILE with "s_feature_compat". =A0It shou=
ld
>> be "s_feature_ro_compat".
>
> Seems right to me, if you add [PATCH] to the subject emails like
> these, and add:
>
> Signed-off-by: ck ya <ykwan0201@gmail.com>
> ---
>
> after the patch,
>
> it'd be ideal.
>
> Thanks,
> -Eric
>
>> Thanks.
>>
>> diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
>> index a48b696..d67c6ec 100644
>> --- a/lib/ext2fs/blknum.c
>> +++ b/lib/ext2fs/blknum.c
>> @@ -49,7 +49,7 @@ blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 struct ext2_inode *inode)
>> =A0{
>> =A0 =A0 =A0 =A0 return (inode->i_blocks |
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((fs->super->s_feature_incompat &
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((fs->super->s_feature_ro_incompat &
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_FEATURE_RO_COMPAT_HUGE_FILE=
) ?
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(__u64) inode->osd2.linux2.l_i_bl=
ocks_hi << 32 : 0)) -
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (inode->i_file_acl ? fs->blocksize >=
> 9 : 0);
>> @@ -62,7 +62,7 @@ blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 struct ext2_inode *inode)
>> =A0{
>> =A0 =A0 =A0 =A0 return (inode->i_blocks |
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((fs->super->s_feature_incompat &
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((fs->super->s_feature_ro_incompat &
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_FEATURE_RO_COMPAT_HUGE_FILE=
) ?
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(__u64)inode->osd2.linux2.l_i_blo=
cks_hi << 32 : 0));
>> =A0}

Hmm, looks strikingly similar to what I posted nearly two months ago. :=
)

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
