From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] print "mostly-printable" xattr strings in debugfs
Date: Mon, 18 Feb 2008 10:35:37 -0600
Message-ID: <47B9B3D9.4020706@redhat.com>
References: <479FEF66.6040308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbYBRQfk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2008 11:35:40 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m1IGZbbX009854
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 11:35:37 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1IGZbPX011468
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 11:35:37 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id m1IGZbNt019993
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 11:35:37 -0500
In-Reply-To: <479FEF66.6040308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Taking a cue from getfattr... if a string is "mostly"
> printable characters, go ahead & print as a string,
> and escape what's left over.

Ted, ping on this?  Since we use selinux a lot, it'd be nice to have
something readable in debugfs output.

If there's anything you don't like about the patch I'll be happy to fix
it up.

Thanks,
-Eric

> so we get:
> 
> Extended attributes stored in inode body: 
>   selinux = "system_u:object_r:root_t:s0\000" (28)
> 
> instead of:
> 
> Extended attributes stored in inode body: 
>   selinux = "73 79 73 74 65 6d 5f 75 3a 6f 62 6a 65 63 74 5f 72 3a 72 6f 6f 74 5f 74 3a 73 30 00 " (28)
> 
> (selinux includes the trailing null in "len" so it
> never prints as a string today)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  
> Index: e2fsprogs-1.40.5/debugfs/debugfs.c
> ===================================================================
> --- e2fsprogs-1.40.5.orig/debugfs/debugfs.c
> +++ e2fsprogs-1.40.5/debugfs/debugfs.c
> @@ -434,19 +434,21 @@ static int list_blocks_proc(ext2_filsys 
>  
>  static void dump_xattr_string(FILE *out, const char *str, int len)
>  {
> -	int printable = 1;
> +	int printable = 0;
>  	int i;
>  	
> -	/* check is string printable? */
> +	/* check: is string "printable enough?" */
>  	for (i = 0; i < len; i++)
> -		if (!isprint(str[i])) {
> -			printable = 0;
> -			break;
> -		}
> +		if (isprint(str[i]))
> +			printable++;
> +
> +	if (printable <= len*7/8)
> +		printable = 0;
>  
>  	for (i = 0; i < len; i++)
>  		if (printable)
> -			fprintf(out, "%c", (unsigned char)str[i]);
> +			fprintf(out, isprint(str[i]) ? "%c" : "\\%03o",
> +				(unsigned char)str[i]);
>  		else
>  			fprintf(out, "%02x ", (unsigned char)str[i]);
>  }
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
