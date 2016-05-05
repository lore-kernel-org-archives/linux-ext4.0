From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH] ext4 crypto: migrate into vfs's crypto engine
Date: Wed, 4 May 2016 21:22:48 -0700
Message-ID: <20160505042248.GB73673@jaegeuk.gateway>
References: <1461629736-16523-1-git-send-email-jaegeuk@kernel.org>
 <20160505032022.GC10776@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160505032022.GC10776@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 04, 2016 at 11:20:22PM -0400, Theodore Ts'o wrote:
> On Mon, Apr 25, 2016 at 05:15:36PM -0700, Jaegeuk Kim wrote:
> > This patch removes the most parts of internal crypto codes.
> > And then, it modifies and adds some ext4-specific crypt codes to use the generic
> > facility.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> 
> So I just tried this patch, and one big problem with it is that it
> breaks backwards compatibility with existing userspace code, which
> assumes that the name of the keys are prefixed with "ext4:".  I see
> that in fs/crypto.h you've changed it to be "fscrypto:".  Which is
> more general, perhaps, but the problem is that it's not what the
> existing shipping code (for example, in the Android N preview release)
> and what e2fsprogs's e4crypto is using.

I also worried about that before, but I thought there was no shipped
fs_encryption-enabled product.
Actually, f2fs has the same issue as well, since "f2fs:" was used before. :(

> If we want to use fscrypto: as a more general prefix, I could see
> doing that, but we need to provide for backwards compatibility ---
> which means that at least for ext4, we will need to look for keys
> using both the new and old prefix, and we would also want change
> e4crypto to set keys with both the "ext4" and the more general
> "fscrypto" prefix.

Got it. Let me add (*key_prefix(inode)) in fscrypt_operations so that filesystem
can give a specific prefix additionally.
Once fscrypto supports both of prefixes, does e4crypto have to set "fscrypto"?
The "ext4" should work all the time tho.

Thanks,

> 
> Cheers,
> 
> 					- Ted
