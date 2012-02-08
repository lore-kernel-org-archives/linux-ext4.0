From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] mke2fs: recognize mke4fs program name
Date: Wed, 8 Feb 2012 15:29:23 -0700
Message-ID: <D6874F6A-E8CF-4938-A178-9B94228C85D9@dilger.ca>
References: <4F32E173.2050103@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:28092 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab2BHW3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Feb 2012 17:29:24 -0500
In-Reply-To: <4F32E173.2050103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-08, at 1:56 PM, Eric Sandeen wrote:
> We shipped "mke4fs" alongside mke2fs in RHEL5, so that ext4-capable
> utilities could be installed without disturbing the venerable e2fsprogs-1.39
> shipped in RHEL5 from the beginning.  But it surprised some users that
> "mke4fs" created ext2 filesystems by default rather than ext4.
> While it was my intent to have the renamed binaries behave exactly
> like the stock ones, it seems that there is some precedence for
> handling "mkeNfs" in the code, so seems reasonable to add 
> mke4fs -> ext4 as well.

Makes sense I think.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> This probably doesn't matter much to upstream, but it seems consistent
> with the existing code, below, if you'd like to include it.
> 
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index e97e44e..410f880 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1014,6 +1014,8 @@ static char **parse_fs_type(const char *fs_type,
> 		ext_type = "ext2";
> 	else if (!strcmp(program_name, "mke3fs"))
> 		ext_type = "ext3";
> +	else if (!strcmp(program_name, "mke4fs"))
> +		ext_type = "ext4";
> 	else if (progname) {
> 		ext_type = strrchr(progname, '/');
> 		if (ext_type)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





