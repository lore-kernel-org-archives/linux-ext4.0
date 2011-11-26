From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 1/2] ext4: let mpage_submit_io works well when blocksize
 < pagesize
Date: Sat, 26 Nov 2011 23:08:24 +0800
Message-ID: <4ED100E8.109@tao.ma>
References: <1322039726-3587-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com,
	tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:34402 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752621Ab1KZPIf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Nov 2011 10:08:35 -0500
In-Reply-To: <1322039726-3587-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Yongqiang,
On 11/23/2011 05:15 PM, Yongqiang Yang wrote:
> If there is a unwritten but clean buffer in a page and there is a dirty buffer
> after the buffer, then mpage_submit_io does not write the dirty buffer out.
> As a result, da_writepages loops forever.
Did you ever meet with this bug or just find it to be a possible bug by
skimming the code? Actually, I can't find a proper way to get a buffer
which can satisfy the check.

Thanks
Tao
> 
> This patch fixes the problem by checking dirty flag.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/inode.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 755f6c7..20a1d17 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1339,8 +1339,11 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
>  					clear_buffer_unwritten(bh);
>  				}
>  
> -				/* skip page if block allocation undone */
> -				if (buffer_delay(bh) || buffer_unwritten(bh))
> +				/*
> +				 * skip page if block allocation undone and
> +				 * block is dirty
> +				 */
> +				if (ext4_bh_delay_or_unwritten(NULL, bh))
>  					skip_page = 1;
>  				bh = bh->b_this_page;
>  				block_start += bh->b_size;


