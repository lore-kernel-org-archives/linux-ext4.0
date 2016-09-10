From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypto: require write access to mount to set
 encryption policy
Date: Sat, 10 Sep 2016 00:15:19 -0400
Message-ID: <20160910041519.nmim57wyptdynwxh@thunk.org>
References: <1473369638-19995-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35718 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750812AbcIJEPq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 10 Sep 2016 00:15:46 -0400
Content-Disposition: inline
In-Reply-To: <1473369638-19995-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 08, 2016 at 02:20:38PM -0700, Eric Biggers wrote:
> [To apply cleanly, my other two patches must be applied before this one]
> 
> Since setting an encryption policy requires writing metadata to the
> filesystem, it should be guarded by mnt_want_write/mnt_drop_write.
> Otherwise, a user could cause a write to a frozen or readonly
> filesystem.  This was handled correctly by f2fs but not by ext4.  Make
> fscrypt_process_policy() handle it rather than relying on the filesystem
> to get it right.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Cc: stable@vger.kernel.org # 4.1+; check fs/{ext4,f2fs}

Thanks, I have this in the ext4.git's fixes branch, but I plan to only
send the other two fixes to Linus, since (a) they are more critical,
and I'd prefer to get an Acked-by from Jaeguk or Changman (as the f2fs
maintainers) before I send this fix to Linus, since it touches f2fs.

Jaeguk, Changman, any objections?

							- Ted
