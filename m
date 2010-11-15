From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: ext4_fill_super shouldn't return 0 on corruption
Date: Mon, 15 Nov 2010 15:55:04 -0600
Message-ID: <4CE1AC38.9040201@redhat.com>
References: <20101115214831.GA18195@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"Patrick J. LoPresti" <lopresti@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab0KOVzV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Nov 2010 16:55:21 -0500
In-Reply-To: <20101115214831.GA18195@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/15/10 3:48 PM, Darrick J. Wong wrote:
> At the start of ext4_fill_super, ret is set to -EINVAL, and any failure path
> out of that function returns this ret.  However, the generic_check_addressable
> clause sets ret = 0 if it passes, which means that a subsequent failure (e.g.
> a group checksum error) returns 0 even though the mount should fail.  This
> causes vfs_kern_mount in turn to think that the mount succeeded (because
> PTR_ERR(0) is false), leading to an oops.
> 
> A simple fix is to avoid using ret for the generic_check_addressable check,
> which was last changed in commit 30ca22c70e3ef0a96ff84de69cd7e8561b416cb2.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

looks right, but one comment below:

> ---
> 
>  fs/ext4/super.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 40131b7..a44bc59 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3257,9 +3257,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	 * Test whether we have more sectors than will fit in sector_t,
>  	 * and whether the max offset is addressable by the page cache.
>  	 */
> -	ret = generic_check_addressable(sb->s_blocksize_bits,
> -					ext4_blocks_count(es));
> -	if (ret) {
> +	if (generic_check_addressable(sb->s_blocksize_bits,
> +				      ext4_blocks_count(es))) {
>  		ext4_msg(sb, KERN_ERR, "filesystem"
>  			 " too large to mount safely on this system");
>  		if (sizeof(sector_t) < 8)

you probably want to set a "ret = -EFBIG" in here.

-Eric

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

