From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ext4: reserve inodes and feature code for 'quota' feature
Date: Tue, 15 Feb 2011 07:23:26 +0200
Message-ID: <AANLkTimLeho=0V2pFBn9Mecvx0bKU5iZnDhv=1nbzzYJ@mail.gmail.com>
References: <AANLkTinvSvUXNR-=pYTNp+dwLNFasuuXqfvVukVkw1qp@mail.gmail.com>
	<4D59DF21.6010304@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Aditya Kali <adityakali@google.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49225 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1BOFX2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Feb 2011 00:23:28 -0500
Received: by qwa26 with SMTP id 26so3674521qwa.19
        for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 21:23:28 -0800 (PST)
In-Reply-To: <4D59DF21.6010304@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 15, 2011 at 4:04 AM, Tao Ma <tm@tao.ma> wrote:
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
>> =A0fs/ext4/ext4.h | =A0 =A03 +++
>> =A01 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 0c8d97b..127f76f 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -209,6 +209,8 @@ struct ext4_io_submit {
>> =A0 */
>> =A0#define =A0 =A0 =A0 EXT4_BAD_INO =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0=
 =A0/* Bad blocks inode */
>> =A0#define EXT4_ROOT_INO =A0 =A0 =A0 =A0 =A02 =A0 =A0 =A0/* Root ino=
de */
>> +#define EXT4_USR_QUOTA_INO =A0 =A0 =A03 =A0 =A0 =A0/* User quota in=
ode */
>> +#define EXT4_GRP_QUOTA_INO =A0 =A0 =A04 =A0 =A0 =A0/* Group quota i=
node */
>> =A0#define EXT4_BOOT_LOADER_INO =A0 5 =A0 =A0 =A0/* Boot loader inod=
e */
>> =A0#define EXT4_UNDEL_DIR_INO =A0 =A0 6 =A0 =A0 =A0/* Undelete direc=
tory inode */
>> =A0#define EXT4_RESIZE_INO =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A07 =A0 =A0 =
=A0/* Reserved group
>> descriptors inode */
>> @@ -1337,6 +1339,7 @@ static inline void ext4_clear_state_flags(stru=
ct
>> ext4_inode_info *ei)
>> =A0#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 0x0010
>> =A0#define EXT4_FEATURE_RO_COMPAT_DIR_NLINK =A0 =A0 =A00x0020
>> =A0#define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE =A0 =A00x0040
>> +#define EXT4_FEATURE_RO_COMPAT_QUOTA =A0 =A0 =A0 =A0 =A0 0x0100
>>
>
> I am just wondering why 0x0080 is skipped here? It is reserved alread=
y?

Yes, it is reserved for EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT

>>
>> =A0#define EXT4_FEATURE_INCOMPAT_COMPRESSION =A0 =A0 0x0001
>> =A0#define EXT4_FEATURE_INCOMPAT_FILETYPE =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A00x0002
>>
>
> Regards,
> Tao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
