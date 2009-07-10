From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] resize2fs: If resize2fs fails, tell the user to run	e2fsck
Date: Fri, 10 Jul 2009 12:42:55 -0600
Message-ID: <20090710184255.GF12939@webber.adilger.int>
References: <1247249267-25715-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61084 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZGJSnZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jul 2009 14:43:25 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6AIhOqp024605
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2009 11:43:25 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KMK00B00X82AL00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 10 Jul 2009 11:43:24 -0700 (PDT)
In-reply-to: <1247249267-25715-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 10, 2009  14:07 -0400, Theodore Ts'o wrote:
> If the resize operation fails in the middle of the operation, mark the
> filesystem as needing to be checked, and tell the user that they
> should run e2fsck -fy on the device.

Isn't it a bit late to mark the filesystem inconsistent AFTER the resize
failed?  If resize2fs dies for some reason it won't be marked.  It makes
more sense to mark the filesystem in error at the start (at first change
at least) and then clear it if there was no error.

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
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
> -- 
> 1.6.3.2.1.gb9f7d.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

