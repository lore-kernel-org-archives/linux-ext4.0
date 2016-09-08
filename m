From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] fscrypto: add authorization check for setting encryption
 policy
Date: Thu, 8 Sep 2016 11:20:56 -0700
Message-ID: <20160908182056.GC132970@google.com>
References: <1473357429-134444-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        tytso@mit.edu, jaegeuk@kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:36043 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753935AbcIHSVe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Sep 2016 14:21:34 -0400
Received: by mail-pf0-f180.google.com with SMTP id 128so20546454pfb.3
        for <linux-ext4@vger.kernel.org>; Thu, 08 Sep 2016 11:21:04 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1473357429-134444-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(Fixing Cc list: the F2FS mailing list is
linux-f2fs-devel@lists.sourceforge.net, not linux-f2fs@vger.kernel.org.)

On Thu, Sep 08, 2016 at 10:57:08AM -0700, Eric Biggers wrote:
> On an ext4 or f2fs filesystem with file encryption supported, a user
> could set an encryption policy on any empty directory(*) to which they
> had readonly access.  This is obviously problematic, since such a
> directory might be owned by another user and the new encryption policy
> would prevent that other user from creating files in their own directory
> (for example).
> 
> Fix this by requiring inode_owner_or_capable() permission to set an
> encryption policy.  This means that either the caller must own the file,
> or the caller must have the capability CAP_FOWNER.
> 
> (*) Or also on any regular file, for f2fs v4.6 and later and ext4
>     v4.8-rc1 and later; a separate bug fix is coming for that.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Cc: stable@vger.kernel.org # 4.1+; check fs/{ext4,f2fs}
> ---
>  fs/crypto/policy.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> index 0f9961e..c9800b1 100644
> --- a/fs/crypto/policy.c
> +++ b/fs/crypto/policy.c
> @@ -95,6 +95,9 @@ static int create_encryption_context_from_policy(struct inode *inode,
>  int fscrypt_process_policy(struct inode *inode,
>  				const struct fscrypt_policy *policy)
>  {
> +	if (!inode_owner_or_capable(inode))
> +		return -EACCES;
> +
>  	if (policy->version != 0)
>  		return -EINVAL;
>  
> -- 
> 2.8.0.rc3.226.g39d4020
> 
