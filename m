From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH] vfs: avoid hang caused by attempting to rmdir an invalid
 file system
Date: Tue, 29 May 2012 13:25:57 +0200
Message-ID: <4FC4B245.9060704@fastmail.fm>
References: <1338226422-8845-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk, sami.liedes@iki.fi
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:45964 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2E2L0K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2012 07:26:10 -0400
In-Reply-To: <1338226422-8845-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/28/2012 07:33 PM, Theodore Ts'o wrote:
> If we rmdir a directory which is a hard link to '.', we will deadlock
> trying to grab the directory's i_mutex.  Check for this condition and
> return EINVAL, which is what we return if the user attempts to rmdir
> "/foo/bar/."
>
> Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
> ---
>   fs/namei.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> diff --git a/fs/namei.c b/fs/namei.c
> index 0062dd1..081f872 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2774,6 +2774,17 @@ static long do_rmdir(int dfd, const char __user *pathname)
>   		error = -ENOENT;
>   		goto exit3;
>   	}
> +	if (nd.path.dentry->d_inode == dentry->d_inode) {

Shouldn't this be tagged as unlikely()?

> +		/*
> +		 * Corrupt file system where there is a symlink to
> +		 * '.'; treat it as if we are trying to rmdir '.'
> +		 *
> +		 * XXX Should we call into the low-level file system
> +		 * to request that the file system be marked corrupt?
> +		 */
> +		error = -EINVAL;
> +		goto exit3;
> +	}
>   	error = mnt_want_write(nd.path.mnt);
>   	if (error)
>   		goto exit3;

Thanks,
Bernd
