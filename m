From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] mke2fs: set upper limit to flex_bg count
Date: Thu, 12 Jun 2014 16:46:11 -0700
Message-ID: <20140612234611.GA9743@birch.djwong.org>
References: <28989C0C9F1C0A428470D967B5FCED372A7E6D@BPXM22GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29833 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaFLXqU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2014 19:46:20 -0400
Content-Disposition: inline
In-Reply-To: <28989C0C9F1C0A428470D967B5FCED372A7E6D@BPXM22GP.gisp.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2014 at 08:37:22AM +0000, Akira Fujita wrote:
> mke2fs -G option allows root user to set flex_bg count (power of 2).
> However ext4 has bad metadata layout if we specify more than or equal to
> 2^32 to mke2fs -G, because of the 32bit shift operation
> in ext2fs_allocate_group_table().
> And the maximum block group count of ext4 is 2^32 -1 (ext4_group_t s_groups_count), 
> so diallow more than 2^32 flex_bg count.
> 
> Steps to reproduce:
> 
> # mke2fs -t ext4 -G 4294967296 DEV
> 
> # dumpe2fs DEV
> <snip>
> Flex block group size:    1          <----- flex_bg is 1!
> <snip>
> Group 0: (Blocks 0-32767)
>   Checksum 0x4afd, unused inodes 7541
>   Primary superblock at 0, Group descriptors at 1-1
>   Reserved GDT blocks at 2-59
>   Block bitmap at 60 (+60), Inode bitmap at 61 (+61)
>   Inode table at 62-533 (+62)
>   32228 free blocks, 7541 free inodes, 2 directories, 7541 unused inodes
>   Free blocks: 540-32767
>   Free inodes: 12-7552
> Group 1: (Blocks 32768-65535) [INODE_UNINIT]
>   Checksum 0xc890, unused inodes 7552
>   Backup superblock at 32768, Group descriptors at 32769-32769
>   Reserved GDT blocks at 32770-32827
>   Block bitmap at 32828 (+60), Inode bitmap at 32829 (+61)
>   Inode table at 32830-33301 (+62)
>   32234 free blocks, 7552 free inodes, 0 directories, 7552 unused inodes
>   Free blocks: 33302-65535
>   Free inodes: 7553-15104
> <snip>
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>

Looks reasonable to me, you can add my Reviewed-by.

--D

> ---
> misc/mke2fs.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index b451cc3..b9145d1 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1605,6 +1605,12 @@ profile_error:
>  					_("flex_bg size must be a power of 2"));
>  				exit(1);
>  			}
> +			if (flex_bg_size > MAX_32_NUM) {
> +				com_err(program_name, 0,
> +				_("flex_bg size (%lu) must be less than"
> +				" or equal to 2^31"), flex_bg_size);
> +				exit(1);
> +			}
>  			break;
>  		case 'i':
>  			inode_ratio = strtoul(optarg, &tmp, 0);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
