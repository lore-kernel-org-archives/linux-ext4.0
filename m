From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypt: remove broken support for detecting
 keyring key revocation
Date: Wed, 15 Mar 2017 13:12:41 -0400
Message-ID: <20170315171241.u3l4a3u5z25c6iim@thunk.org>
References: <20170221230711.85222-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers@google.com>, Richard Weinberger <richard@nod.at>,
	linux-kernel@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org, stable@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-ext4@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20170221230711.85222-1-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 21, 2017 at 03:07:11PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Filesystem encryption ostensibly supported revoking a keyring key that
> had been used to "unlock" encrypted files, causing those files to become
> "locked" again.  This was, however, buggy for several reasons, the most
> severe of which was that when key revocation happened to be detected for
> an inode, its fscrypt_info was immediately freed, even while other
> threads could be using it for encryption or decryption concurrently.
> This could be exploited to crash the kernel or worse.
> 
> This patch fixes the use-after-free by removing the code which detects
> the keyring key having been revoked, invalidated, or expired.  Instead,
> an encrypted inode that is "unlocked" now simply remains unlocked until
> it is evicted from memory.  Note that this is no worse than the case for
> block device-level encryption, e.g. dm-crypt, and it still remains
> possible for a privileged user to evict unused pages, inodes, and
> dentries by running 'sync; echo 3 > /proc/sys/vm/drop_caches', or by
> simply unmounting the filesystem.  In fact, one of those actions was
> already needed anyway for key revocation to work even somewhat sanely.
> This change is not expected to break any applications.
> 
> In the future I'd like to implement a real API for fscrypt key
> revocation that interacts sanely with ongoing filesystem operations ---
> waiting for existing operations to complete and blocking new operations,
> and invalidating and sanitizing key material and plaintext from the VFS
> caches.  But this is a hard problem, and for now this bug must be fixed.
> 
> This bug affected almost all versions of ext4, f2fs, and ubifs
> encryption, and it was potentially reachable in any kernel configured
> with encryption support (CONFIG_EXT4_ENCRYPTION=y,
> CONFIG_EXT4_FS_ENCRYPTION=y, CONFIG_F2FS_FS_ENCRYPTION=y, or
> CONFIG_UBIFS_FS_ENCRYPTION=y).  Note that older kernels did not use the
> shared fs/crypto/ code, but due to the potential security implications
> of this bug, it may still be worthwhile to backport this fix to them.
> 
> Fixes: b7236e21d55f ("ext4 crypto: reorganize how we store keys in the inode")
> Cc: stable@vger.kernel.org # v4.2+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

						- Ted

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
