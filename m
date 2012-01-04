From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH] mke2fs: correct help text for option -G of mke2fs
Date: Wed, 4 Jan 2012 00:22:58 -0700
Message-ID: <65F5DCD8-3B25-4F40-8966-2C23700E0CDA@gmail.com>
References: <1325647785-8672-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52086 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2ADHWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2012 02:22:48 -0500
Received: by iaeh11 with SMTP id h11so32129760iae.19
        for <linux-ext4@vger.kernel.org>; Tue, 03 Jan 2012 23:22:48 -0800 (PST)
In-Reply-To: <1325647785-8672-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Probably "flex_group_size" or "flex_group_factor" is as clear and a lot shorter. 

Cheers, Andreas

On 2012-01-03, at 20:29, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:

> The option '-G' is used to pass number of groups in a flex_bg, the
> previous help text - 'meta-group-size' - could confuse users with
> meta_bg.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> misc/mke2fs.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 0ef2531..52746fe 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -116,7 +116,7 @@ static void usage(void)
>    fprintf(stderr, _("Usage: %s [-c|-l filename] [-b block-size] "
>    "[-C cluster-size]\n\t[-i bytes-per-inode] [-I inode-size] "
>    "[-J journal-options]\n"
> -    "\t[-G meta group size] [-N number-of-inodes]\n"
> +    "\t[-G number-of-groups-per-flex_bg] [-N number-of-inodes]\n"
>    "\t[-m reserved-blocks-percentage] [-o creator-os]\n"
>    "\t[-g blocks-per-group] [-L volume-label] "
>    "[-M last-mounted-directory]\n\t[-O feature[,...]] "
> -- 
> 1.7.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
