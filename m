From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Use s_csum_seed instead of i_csum_seed for xattr
 block csum.
Date: Mon, 03 Sep 2012 11:14:19 +0800
Message-ID: <5044208B.2080008@tao.ma>
References: <1340547236-2838-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:51452 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755010Ab2ICDOY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Sep 2012 23:14:24 -0400
In-Reply-To: <1340547236-2838-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
	As the corresponding kernel change has been merged, can this patch be
merged to the e2fsporgs also?

Thanks
Tao
On 06/24/2012 10:13 PM, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In xattr block operation, we use h_refcount to indicate whether the
> xattr block is shared among many inodes. And xattr block csum uses
> s_csum_seed if it is shared and i_csum_seed if it belongs to
> one inode. But this has a problem. So consider the block is shared
> first bewteen inode A and B, and B has some xattr update and CoW
> the xattr block. When it updates the *old* xattr block(because
> of the h_refcount change) and calls ext4_xattr_release_block, we
> has no idea that inode A is the real owner of the *old* xattr
> block and we can't use the i_csum_seed of inode A either in xattr
> block csum calculation. And I don't think we have an easy way to
> find inode A.
> 
> So this patch just removes the tricky i_csum_seed and we now uses
> s_csum_seed every time for the xattr block csum. The corresponding
> patch for the e2fsprogs will be sent in another patch.
> 
> This is spotted by xfstests 117.
> 
> Cc: Darrick J. Wong <djwong@us.ibm.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext4/xattr.c |   11 ++++-------
>  1 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index e56c9ed..2cdb98d 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -127,19 +127,16 @@ static __le32 ext4_xattr_block_csum(struct inode *inode,
>  				    struct ext4_xattr_header *hdr)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> -	struct ext4_inode_info *ei = EXT4_I(inode);
>  	__u32 csum, old;
>  
>  	old = hdr->h_checksum;
>  	hdr->h_checksum = 0;
> -	if (le32_to_cpu(hdr->h_refcount) != 1) {
> -		block_nr = cpu_to_le64(block_nr);
> -		csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)&block_nr,
> -				   sizeof(block_nr));
> -	} else
> -		csum = ei->i_csum_seed;
> +	block_nr = cpu_to_le64(block_nr);
> +	csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)&block_nr,
> +			   sizeof(block_nr));
>  	csum = ext4_chksum(sbi, csum, (__u8 *)hdr,
>  			   EXT4_BLOCK_SIZE(inode->i_sb));
> +
>  	hdr->h_checksum = old;
>  	return cpu_to_le32(csum);
>  }
> 

