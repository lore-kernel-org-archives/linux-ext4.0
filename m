From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fuse2fs: delete unused variables
Date: Mon, 25 Apr 2016 15:50:22 -0400
Message-ID: <20160425195022.GA24779@thunk.org>
References: <20160419192100.GA5405@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38194 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933450AbcDYTu0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Apr 2016 15:50:26 -0400
Content-Disposition: inline
In-Reply-To: <20160419192100.GA5405@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 19, 2016 at 12:21:00PM -0700, Darrick J. Wong wrote:
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  misc/fuse2fs.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
> index c75527e..5a19f23 100644
> --- a/misc/fuse2fs.c
> +++ b/misc/fuse2fs.c
> @@ -3712,8 +3712,7 @@ int main(int argc, char *argv[])
>  	struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
>  	struct fuse2fs fctx;
>  	errcode_t err;
> -	char *tok, *arg, *logfile;
> -	int i;
> +	char *logfile;
>  	char extra_args[BUFSIZ];
>  	int ret = 0, flags = EXT2_FLAG_64BITS | EXT2_FLAG_EXCLUSIVE;
>  

Thanks, applied.

							- Ted
