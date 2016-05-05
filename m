From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4 crypto: migrate into vfs's crypto engine
Date: Thu, 5 May 2016 08:44:12 -0400
Message-ID: <20160505124412.GE10776@thunk.org>
References: <1461629736-16523-1-git-send-email-jaegeuk@kernel.org>
 <20160505032022.GC10776@thunk.org>
 <20160505042248.GB73673@jaegeuk.gateway>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160505042248.GB73673@jaegeuk.gateway>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 04, 2016 at 09:22:48PM -0700, Jaegeuk Kim wrote:
> 
> Got it. Let me add (*key_prefix(inode)) in fscrypt_operations so that filesystem
> can give a specific prefix additionally.
> Once fscrypto supports both of prefixes, does e4crypto have to set "fscrypto"?
> The "ext4" should work all the time tho.

Well, the question is what userspace tool should be used for the
non-Android case?

The other thing to consider is the cost of doing lookups in two
keyrings all of the time.  I'm not sure how much overhead there is,
but if it's significant, it might be time to hang a keyring off the
superblock, and to start migrating to a model where keys are globally
available to the file system once they get their (either implicitly
because they are on a user's keyring, or explicitly via a new ioctl),
and when they are removed (either implicitly because a key has been
invalidated, or explicitly via a new ioctl), when a key gets added or
removed from the file system global keyring, we bump a sequence
counter so we can invalidate negative or positve dcache entries as
appropriate.

This goes back to the problem where the page and dentry caches are
global and the using per-user or per-session keyrings doesn't map
cleanly to the page and dentry caches.

						- Ted
