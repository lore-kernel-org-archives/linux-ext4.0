From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] resize2fs: If resize2fs fails, tell the user to run e2fsck
Date: Fri, 10 Jul 2009 13:09:48 -0500
Message-ID: <4A5783EC.90601@redhat.com>
References: <1247249267-25715-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55659 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbZGJSJz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jul 2009 14:09:55 -0400
In-Reply-To: <1247249267-25715-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> If the resize operation fails in the middle of the operation, mark the
> filesystem as needing to be checked, and tell the user that they
> should run e2fsck -fy on the device.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Good plan.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  resize/main.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/resize/main.c b/resize/main.c
> index 2dae161..990a967 100644
> --- a/resize/main.c
> +++ b/resize/main.c
> @@ -455,7 +455,12 @@ int main (int argc, char ** argv)
>  	if (retval) {
>  		com_err(program_name, retval, _("while trying to resize %s"),
>  			device_name);
> -		ext2fs_close (fs);
> +		fprintf(stderr,
> +			_("Please run 'e2fsck -fy %s' to fix the filesystem\n"
> +			  "after the aborted resize operation"), device_name);
> +		fs->super->s_state |= EXT2_ERROR_FS;
> +		ext2fs_mark_super_dirty(fs);
> +		ext2fs_close(fs);
>  		exit(1);
>  	}
>  	printf(_("The filesystem on %s is now %u blocks long.\n\n"),

