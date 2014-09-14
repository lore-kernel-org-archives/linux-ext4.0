From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] jbd2: free bh when descriptor block checksum fails
Date: Sun, 14 Sep 2014 14:13:43 -0500
Message-ID: <5415E8E7.7010001@redhat.com>
References: <20140914173252.31996.86784.stgit@birch.djwong.org> <20140914173305.31996.71172.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbaINTNq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Sep 2014 15:13:46 -0400
In-Reply-To: <20140914173305.31996.71172.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/14/14 12:33 PM, Darrick J. Wong wrote:
> Free the buffer head if the journal descriptor block fails checksum
> verification.
> 
> This is the jbd2 port of the e2fsprogs patch "e2fsck: free bh on csum
> verify error in do_one_pass".
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/jbd2/recovery.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
> index 9b329b5..bcbef08 100644
> --- a/fs/jbd2/recovery.c
> +++ b/fs/jbd2/recovery.c
> @@ -525,6 +525,7 @@ static int do_one_pass(journal_t *journal,
>  			    !jbd2_descr_block_csum_verify(journal,
>  							  bh->b_data)) {
>  				err = -EIO;
> +				brelse(bh);
>  				goto failed;
>  			}
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

