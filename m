From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: fix cpu_vs_disk conversions
Date: Wed, 3 Apr 2013 11:37:42 -0400
Message-ID: <20130403153742.GA14991@thunk.org>
References: <1364986711-3630-1-git-send-email-dmonakhov@openvz.org>
 <1364986711-3630-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58957 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761053Ab3DCPhq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 11:37:46 -0400
Content-Disposition: inline
In-Reply-To: <1364986711-3630-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 03, 2013 at 02:58:31PM +0400, Dmitry Monakhov wrote:
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 3a120b2..34da740 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -123,16 +123,15 @@ static __le32 ext4_xattr_block_csum(struct inode *inode,
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>  	__u32 csum, old;
> -
> -	old = hdr->h_checksum;
> +	__le64 dsk_block_nr = cpu_to_le64(block_nr);
> +	old = le32_to_cpu(hdr->h_checksum);

We're just saving and restoring hdr->h_checksum.  So instead of
byte-swapping the checksum in old, and then swapping it back, why not
just do this instead:

     __le32 old;

     old = hdr->h_checksum;
     ...
     hdr->h_checksum = old;

					- Ted
