From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 08/10] debugfs: remove dead code
Date: Tue, 07 Jan 2014 11:14:39 -0600
Message-ID: <52CC35FF.8000302@redhat.com>
References: <1389106394-31898-1-git-send-email-tytso@mit.edu> <1389106394-31898-8-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbaAGROn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 12:14:43 -0500
In-Reply-To: <1389106394-31898-8-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/7/14, 8:53 AM, Theodore Ts'o wrote:
> Addresses-Coverity-Id: #1138573
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

FWIW, Darrick had already sent this as part of

"[PATCH 1/2] misc: fix resource leaks in e2fsprogs"

- but I suppose small targeted patches are better.

-Eric

> ---
>  debugfs/debugfs.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index 998af33..0e56ead 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -289,8 +289,6 @@ void do_init_filesys(int argc, char **argv)
>  	if (err)
>  		return;
>  	ext2fs_blocks_count_set(&param, blocks);
> -	if (err)
> -		return;
>  	retval = ext2fs_initialize(argv[1], 0, &param,
>  				   unix_io_manager, &current_fs);
>  	if (retval) {
> 

