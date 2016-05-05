From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4 crypto: migrate into vfs's crypto engine
Date: Wed, 4 May 2016 23:20:22 -0400
Message-ID: <20160505032022.GC10776@thunk.org>
References: <1461629736-16523-1-git-send-email-jaegeuk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461629736-16523-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 25, 2016 at 05:15:36PM -0700, Jaegeuk Kim wrote:
> This patch removes the most parts of internal crypto codes.
> And then, it modifies and adds some ext4-specific crypt codes to use the generic
> facility.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

So I just tried this patch, and one big problem with it is that it
breaks backwards compatibility with existing userspace code, which
assumes that the name of the keys are prefixed with "ext4:".  I see
that in fs/crypto.h you've changed it to be "fscrypto:".  Which is
more general, perhaps, but the problem is that it's not what the
existing shipping code (for example, in the Android N preview release)
and what e2fsprogs's e4crypto is using.

If we want to use fscrypto: as a more general prefix, I could see
doing that, but we need to provide for backwards compatibility ---
which means that at least for ext4, we will need to look for keys
using both the new and old prefix, and we would also want change
e4crypto to set keys with both the "ext4" and the more general
"fscrypto" prefix.

Cheers,

					- Ted
