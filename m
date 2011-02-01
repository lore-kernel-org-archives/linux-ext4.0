From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsprogs: Fix how we treat user-spcified filesystem size
Date: Tue, 1 Feb 2011 13:37:21 -0700
Message-ID: <140BFB14-31E6-4E76-B1DA-5CD8F54FDD5B@dilger.ca>
References: <1296587912-16756-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, tytso@MIT.EDU
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:36498 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1BAUhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Feb 2011 15:37:23 -0500
In-Reply-To: <1296587912-16756-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-01, at 12:18, Lukas Czerner wrote:
> +Optionally, the
> +.I filesystem-size
> +parameter may be suffixed by one of the following the units
> +designators: 'b', 's', 'K', 'M', or 'G',
> +for blocks count, 512 byte sectors, kilobytes, megabytes, or gigabytes,
> +respectively.

My reading of parse_num_blocks() shows that 'T' is also accepted as a suffix for terabytes, which I was otherwise going to suggest be added, since this is the normal size for filesystems today.  It might be worthwhile _briefly_ mentioning here that these are binary/power-of-two values and not decimal values, instead of the rant further below.

Minor technical nit - the proper metric value is lower-case 'k' for kilo, though the upper-case 'M', 'G', and 'T' are correct for mega-, giga-, and terabytes.

> diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
> --- a/resize/resize2fs.8.in
> +++ b/resize/resize2fs.8.in
> @@ -38,13 +38,13 @@ The
> +designators: 'b', 's', 'K', 'M', or 'G',
> +for blocks count, 512 byte sectors, kilobytes, megabytes, or gigabytes,
> +respectively. The

Similarly, this also supports 'T' for terabytes, since it uses the same parse_num_blocks() function.

Cheers, Andreas





