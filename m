From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Add missing unlock to an error path in
	ext4_quota_write()
Date: Fri, 27 Jun 2008 16:54:34 -0700
Message-ID: <1214610874.6837.22.camel@mingming-laptop>
References: n <12144791432214-git-send-email-jack@suse.cz>
	 <12144791441146-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52089 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759696AbYF0Xyh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jun 2008 19:54:37 -0400
In-Reply-To: <12144791441146-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Thu, 2008-06-26 at 13:19 +0200, Jan Kara wrote:
> When write in ext4_quota_write() fails, we have to properly release
> i_mutex. One error path has been missing the unlock...
> 

Added to ext4 patch queue,

thanks
Mingming
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/super.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index cb96f12..02bf243 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3337,8 +3337,10 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
>  		blk++;
>  	}
>  out:
> -	if (len == towrite)
> +	if (len == towrite) {
> +		mutex_unlock(&inode->i_mutex);
>  		return err;
> +	}
>  	if (inode->i_size < off+len-towrite) {
>  		i_size_write(inode, off+len-towrite);
>  		EXT4_I(inode)->i_disksize = inode->i_size;

