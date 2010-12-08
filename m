From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: fix typo in ext4_find_entry()
Date: Wed, 08 Dec 2010 11:53:13 -0600
Message-ID: <4CFFC609.1090506@redhat.com>
References: <1291826002-24989-1-git-send-email-aaro.koskinen@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, ext-phil.2.carmody@nokia.com
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab0LHRxT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Dec 2010 12:53:19 -0500
In-Reply-To: <1291826002-24989-1-git-send-email-aaro.koskinen@nokia.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/08/2010 10:33 AM, Aaro Koskinen wrote:
> There should be a check for NUL character instead of '0'.
> 
> Reported-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
> ---
>  fs/ext4/namei.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 92203b8..dc40e75 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -872,7 +872,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
>  	if (namelen > EXT4_NAME_LEN)
>  		return NULL;
>  	if ((namelen <= 2) && (name[0] == '.') &&
> -	    (name[1] == '.' || name[1] == '0')) {
> +	    (name[1] == '.' || name[1] == '\0')) {
>  		/*
>  		 * "." or ".." will only be in the first block
>  		 * NFS may look up ".."; "." should be handled by the VFS

Yep, as it was reviewed on the list when originally sent, oops! ;)

-Eric
