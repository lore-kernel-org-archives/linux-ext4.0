From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH] fscrypto: require write access to mount to
 set encryption policy
Date: Fri, 9 Sep 2016 21:40:49 -0700
Message-ID: <20160910044049.GD34151@jaegeuk>
References: <1473369638-19995-1-git-send-email-ebiggers@google.com>
	<20160910041519.nmim57wyptdynwxh@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, Eric Biggers <ebiggers@google.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20160910041519.nmim57wyptdynwxh@thunk.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Sat, Sep 10, 2016 at 12:15:19AM -0400, Theodore Ts'o wrote:
> On Thu, Sep 08, 2016 at 02:20:38PM -0700, Eric Biggers wrote:
> > [To apply cleanly, my other two patches must be applied before this one]
> > 
> > Since setting an encryption policy requires writing metadata to the
> > filesystem, it should be guarded by mnt_want_write/mnt_drop_write.
> > Otherwise, a user could cause a write to a frozen or readonly
> > filesystem.  This was handled correctly by f2fs but not by ext4.  Make
> > fscrypt_process_policy() handle it rather than relying on the filesystem
> > to get it right.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Jaegeuk Kim <jaegeuk@kernel.org>

> > Cc: stable@vger.kernel.org # 4.1+; check fs/{ext4,f2fs}
> 
> Thanks, I have this in the ext4.git's fixes branch, but I plan to only
> send the other two fixes to Linus, since (a) they are more critical,
> and I'd prefer to get an Acked-by from Jaeguk or Changman (as the f2fs
> maintainers) before I send this fix to Linus, since it touches f2fs.

Thank you, Ted.

It'd be better to fix the below basic warnings tho.

# ./scripts/checkpatch.pl [patch]

WARNING: line over 80 characters
#147: FILE: fs/crypto/policy.c:120:
+			ret = create_encryption_context_from_policy(inode, policy);

WARNING: line over 80 characters
#148: FILE: fs/crypto/policy.c:121:
+	} else if (!is_encryption_context_consistent_with_policy(inode, policy)) {

	WARNING: Prefer [subsystem eg: netdev]_warn([subsystem]dev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
#149: FILE: fs/crypto/policy.c:122:
+		printk(KERN_WARNING

total: 0 errors, 3 warnings, 107 lines checked

Thanks,



> 
> 							- Ted

------------------------------------------------------------------------------
