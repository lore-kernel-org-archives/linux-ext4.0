From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: reserve inodes and feature code for 'quota' feature
Date: Tue, 15 Feb 2011 10:04:17 +0800
Message-ID: <4D59DF21.6010304@tao.ma>
References: <AANLkTinvSvUXNR-=pYTNp+dwLNFasuuXqfvVukVkw1qp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:39887 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754020Ab1BOCE0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Feb 2011 21:04:26 -0500
In-Reply-To: <AANLkTinvSvUXNR-=pYTNp+dwLNFasuuXqfvVukVkw1qp@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Aditya,
On 02/15/2011 09:06 AM, Aditya Kali wrote:
> I am working on patch to add quota as a built-in feature for ext4
> filesystem. The implementation is based on the design given at
> https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in_Ext4.
> This patch reserves the inode numbers 3 and 4 for quota purposes and
> also reserves EXT4_FEATURE_RO_COMPAT_QUOTA feature code.
>
> Signed-off-by: Aditya Kali<adityakali@google.com>
> ---
>   fs/ext4/ext4.h |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 0c8d97b..127f76f 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -209,6 +209,8 @@ struct ext4_io_submit {
>    */
>   #define	EXT4_BAD_INO		 1	/* Bad blocks inode */
>   #define EXT4_ROOT_INO		 2	/* Root inode */
> +#define EXT4_USR_QUOTA_INO	 3	/* User quota inode */
> +#define EXT4_GRP_QUOTA_INO	 4	/* Group quota inode */
>   #define EXT4_BOOT_LOADER_INO	 5	/* Boot loader inode */
>   #define EXT4_UNDEL_DIR_INO	 6	/* Undelete directory inode */
>   #define EXT4_RESIZE_INO		 7	/* Reserved group descriptors inode */
> @@ -1337,6 +1339,7 @@ static inline void ext4_clear_state_flags(struct
> ext4_inode_info *ei)
>   #define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
>   #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
>   #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
> +#define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
>    
I am just wondering why 0x0080 is skipped here? It is reserved already?
>   #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
>   #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
>    
Regards,
Tao
