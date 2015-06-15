From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] jbd2: fix ocfs2 corrupt when updating journal
 superblock fails
Date: Mon, 15 Jun 2015 15:02:54 -0400
Message-ID: <20150615190254.GC5003@thunk.org>
References: <557E703D.2060709@huawei.com>
 <20150615130844.GF4368@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joseph Qi <joseph.qi@huawei.com>, linux-ext4@vger.kernel.org,
	"ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	jiangyiwen <jiangyiwen@huawei.com>, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150615130844.GF4368@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 15, 2015 at 03:08:44PM +0200, Jan Kara wrote:
>   The patch looks good but it seems to be against relatively old kernel
> version. Can you please rebase your patch against current kernel? Thanks!

It applied cleanly for me, but there's quite a few commits building up
in the ext4.git tree for the next merge cycle (see shortlog below).
I'm guessing that perhaps Joseph generated his patch versus the
linux-next tree?

							- Ted

Andreas Dilger (1):
      ext4: improve warning directory handling messages

Chao Yu (1):
      ext4 crypto: release crypto resource on module exit

David Moore (1):
      ext4: BUG_ON assertion repeated for inode1, not done for inode2

Dmitry Monakhov (1):
      jbd2: use GFP_NOFS in jbd2_cleanup_journal_tail()

Fabian Frederick (3):
      ext4 crypto: fix sparse warnings in fs/ext4/ioctl.c
      ext4: use swap() in memswap()
      ext4: use swap() in mext_page_double_lock()

Jan Kara (4):
      jbd2: simplify code flow in do_get_write_access()
      jbd2: simplify error path on allocation failure in do_get_write_access()
      jbd2: more simplifications in do_get_write_access()
      jbd2: speedup jbd2_journal_get_[write|undo]_access()

Joseph Qi (1):
      jbd2: fix ocfs2 corrupt when updating journal superblock fails

Lukas Czerner (5):
      ext4: verify block bitmap even after fresh initialization
      ext4: try to initialize all groups we can in case of failure on ppc64
      ext4: return error code from ext4_mb_good_group()
      ext4: recalculate journal credits as inode depth changes
      ext4: wait for existing dio workers in ext4_alloc_file_blocks()

Michal Hocko (1):
      jbd2: revert must-not-fail allocation loops back to GFP_NOFAIL

Namjae Jeon (1):
      ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate

Rasmus Villemoes (1):
      ext4: mballoc: avoid 20-argument function call

Theodore Ts'o (23):
      ext4 crypto: optimize filename encryption
      ext4 crypto: don't allocate a page when encrypting/decrypting file names
      ext4 crypto: separate kernel and userspace structure for the key
      ext4 crypto: reorganize how we store keys in the inode
      ext4: clean up superblock encryption mode fields
      ext4 crypto: use slab caches
      ext4 crypto: get rid of ci_mode from struct ext4_crypt_info
      ext4 crypto: shrink size of the ext4_crypto_ctx structure
      ext4 crypto: require CONFIG_CRYPTO_CTR if ext4 encryption is enabled
      ext4 crypto: use per-inode tfm structure
      ext4 crypto: fix memory leaks in ext4_encrypted_zeroout
      ext4 crypto: set up encryption info for new inodes in ext4_inherit_context()
      ext4 crypto: make sure the encryption info is initialized on opendir(2)
      ext4 crypto: encrypt tmpfile located in encryption protected directory
      ext4 crypto: enforce crypto policy restrictions on cross-renames
      ext4 crypto: policies may only be set on directories
      ext4 crypto: clean up error handling in ext4_fname_setup_filename
      ext4 crypto: allocate the right amount of memory for the on-disk symlink
      ext4 crypto: handle unexpected lack of encryption keys
      ext4 crypto: allocate bounce pages using GFP_NOWAIT
      ext4 crypto: fix ext4_get_crypto_ctx()'s calling convention in ext4_decrypt_one
      ext4 crypto: fail the mount if blocksize != pagesize
      ext4: fix race between truncate and __ext4_journalled_writepage()


							
