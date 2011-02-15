From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH] ext4: reserve inodes and feature code for 'quota' feature
Date: Mon, 14 Feb 2011 21:27:24 -0800
Message-ID: <AANLkTimx5OPukk9SYDySjCNEAwPgHY3J6OX-FeYaAv0Y@mail.gmail.com>
References: <AANLkTinvSvUXNR-=pYTNp+dwLNFasuuXqfvVukVkw1qp@mail.gmail.com> <4D59DF21.6010304@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:8348 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1BOF1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Feb 2011 00:27:50 -0500
Received: from wpaz9.hot.corp.google.com (wpaz9.hot.corp.google.com [172.24.198.73])
	by smtp-out.google.com with ESMTP id p1F5RnIn007820
	for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 21:27:49 -0800
Received: from pxi11 (pxi11.prod.google.com [10.243.27.11])
	by wpaz9.hot.corp.google.com with ESMTP id p1F5Rllx008112
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 21:27:47 -0800
Received: by pxi11 with SMTP id 11so1058115pxi.35
        for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 21:27:46 -0800 (PST)
In-Reply-To: <4D59DF21.6010304@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The code 0x0080 seems to be reserved for
EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT in e2fsprogs/lib/ext2fs/ext2_fs.h
for Next3 snapshot feature.

Thanks,
--
Aditya



On Mon, Feb 14, 2011 at 6:04 PM, Tao Ma <tm@tao.ma> wrote:
> Hi Aditya,
> On 02/15/2011 09:06 AM, Aditya Kali wrote:
>>
>> I am working on patch to add quota as a built-in feature for ext4
>> filesystem. The implementation is based on the design given at
>> https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in=
_Ext4.
>> This patch reserves the inode numbers 3 and 4 for quota purposes and
>> also reserves EXT4_FEATURE_RO_COMPAT_QUOTA feature code.
>>
>> Signed-off-by: Aditya Kali<adityakali@google.com>
>> ---
>> =C2=A0fs/ext4/ext4.h | =C2=A0 =C2=A03 +++
>> =C2=A01 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 0c8d97b..127f76f 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -209,6 +209,8 @@ struct ext4_io_submit {
>> =C2=A0 */
>> =C2=A0#define =C2=A0 =C2=A0 =C2=A0 EXT4_BAD_INO =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0/* Bad blocks inode */
>> =C2=A0#define EXT4_ROOT_INO =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0=
 =C2=A0 =C2=A0/* Root inode */
>> +#define EXT4_USR_QUOTA_INO =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0=
/* User quota inode */
>> +#define EXT4_GRP_QUOTA_INO =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0=
/* Group quota inode */
>> =C2=A0#define EXT4_BOOT_LOADER_INO =C2=A0 5 =C2=A0 =C2=A0 =C2=A0/* B=
oot loader inode */
>> =C2=A0#define EXT4_UNDEL_DIR_INO =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0=
/* Undelete directory inode */
>> =C2=A0#define EXT4_RESIZE_INO =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0/* Reserved group
>> descriptors inode */
>> @@ -1337,6 +1339,7 @@ static inline void ext4_clear_state_flags(stru=
ct
>> ext4_inode_info *ei)
>> =C2=A0#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0x0010
>> =C2=A0#define EXT4_FEATURE_RO_COMPAT_DIR_NLINK =C2=A0 =C2=A0 =C2=A00=
x0020
>> =C2=A0#define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE =C2=A0 =C2=A00x0040
>> +#define EXT4_FEATURE_RO_COMPAT_QUOTA =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0x0100
>>
>
> I am just wondering why 0x0080 is skipped here? It is reserved alread=
y?
>>
>> =C2=A0#define EXT4_FEATURE_INCOMPAT_COMPRESSION =C2=A0 =C2=A0 0x0001
>> =C2=A0#define EXT4_FEATURE_INCOMPAT_FILETYPE =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0002
>>
>
> Regards,
> Tao
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
