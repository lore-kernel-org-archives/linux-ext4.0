From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] debugfs: remove misplaced "MMP is unsupported" message.
Date: Tue, 23 Jan 2018 21:04:24 -0800
Message-ID: <20180124050424.GD5594@magnolia>
References: <1516764797-27781-1-git-send-email-tgnottingham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Tyson Nottingham <tgnottingham@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59400 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932135AbeAXFE3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jan 2018 00:04:29 -0500
Content-Disposition: inline
In-Reply-To: <1516764797-27781-1-git-send-email-tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 23, 2018 at 07:33:17PM -0800, Tyson Nottingham wrote:
> This message was inadvertently copied from the version of do_dump_mmp
> that is used when CONFIG_MMP is disabled.
> 
> Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  debugfs/debugfs.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index 91ededf..e46532f 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -2366,8 +2366,6 @@ void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
>  	fprintf(stdout, "device_name: %s\n", mmp_s->mmp_bdevname);
>  	fprintf(stdout, "magic: 0x%x\n", mmp_s->mmp_magic);
>  	fprintf(stdout, "checksum: 0x%08x\n", mmp_s->mmp_checksum);
> -	fprintf(stdout, "MMP is unsupported, please recompile with "
> -	                "--enable-mmp\n");
>  }
>  #else
>  void do_dump_mmp(int argc EXT2FS_ATTR((unused)),
> -- 
> 2.7.4
> 
