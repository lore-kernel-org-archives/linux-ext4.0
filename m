From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypto: add authorization check for setting encryption
 policy
Date: Fri, 9 Sep 2016 23:37:59 -0400
Message-ID: <20160910033759.qsvg4loedccqc7if@thunk.org>
References: <1473357429-134444-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs@vger.kernel.org, jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35640 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753073AbcIJDiz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 9 Sep 2016 23:38:55 -0400
Content-Disposition: inline
In-Reply-To: <1473357429-134444-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

Thanks, applied.  (Jaeguk, I plan to send this to Linus via the
ext4.git tree as a fix for v4.8)

					- Ted
