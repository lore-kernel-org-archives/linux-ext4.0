From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 1/4] misc: quiet minor compiler errors
Date: Fri, 23 Sep 2011 17:44:13 -0600
Message-ID: <A044F830-D13A-40CE-9DC5-1CD3A91314BF@whamcloud.com>
References: <1316821124-7461-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62434 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1IWXoR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2011 19:44:17 -0400
Received: by gwb15 with SMTP id 15so4089045gwb.19
        for <linux-ext4@vger.kernel.org>; Fri, 23 Sep 2011 16:44:17 -0700 (PDT)
In-Reply-To: <1316821124-7461-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-23, at 5:38 PM, Andreas Dilger wrote:
> Several compiler errors are quieted:
> - use of stat64/open64 on OSX (deprecated API)

I forgot to mention in the commit summary, but worthwhile to mention so
that this patch is accepted upstream promptly, is that this also fixes
a bug in the ext2fs_stat() implementation if stat64() does not exist.

The fallback code was incorrectly using open() instead of stat(), but
since stat64() has existed for ages it would only be seen in unusual
cases (e.g. compiling on OS/X).

> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 1b9acc3..ab47621 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> 
> _INLINE_ int ext2fs_stat(const char *path, ext2fs_struct_stat *buf)
> {
> -#ifdef HAVE_OPEN64
> +#if defined(HAVE_STAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
> 	return stat64(path, buf);
> #else
> -	return open(path, buf);
> +	return stat(path, buf);
> +#endif
> +}

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



