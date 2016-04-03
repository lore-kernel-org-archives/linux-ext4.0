From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 00/13] fscrypto: cleanups and fixes
Date: Sun,  3 Apr 2016 00:21:51 -0500
Message-ID: <1459660924-2960-1-git-send-email-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, Eric Biggers <ebiggers3@gmail.com>, mhalcrow@google.com,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, jaegeuk@kernel.org,
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

This patchset includes various cleanups for the new filesystem encryption
code as well as some bug fixes for the FS_IOC_SET_ENCRYPTION_POLICY ioctl.

Eric Biggers (13):
  fscrypto: remove unnecessary includes
  fscrypto: rename some functions for clarity
  fscrypto: rename functions to load and unload inode encryption info
  fscrypto: return bool instead of int where appropriate
  fscrypto: comment improvements and fixes
  fscrypto: crypto_alloc_skcipher() always returns an ERR_PTR(), never
    NULL
  fscrypto: simplify building key descriptor string
  fscrypto: use standard macros from kernel.h
  fscrypto: make fname_encrypt() actually return length of ciphertext
  fscrypto: restrict setting new policy to empty files and directories
    only
  fscrypto: restrict setting encryption policy to inode owner
  fscrypto: require write access to mount to set encryption policy
  fscrypto: improve error handling in fscrypt_set_policy()

 fs/crypto/crypto.c       |  25 +++++----
 fs/crypto/fname.c        |  72 ++++++++++++++++----------
 fs/crypto/keyinfo.c      |  47 ++++++++---------
 fs/crypto/policy.c       | 131 +++++++++++++++++++++++++++--------------------
 fs/f2fs/dir.c            |   4 +-
 fs/f2fs/f2fs.h           |   6 +--
 fs/f2fs/file.c           |  10 ++--
 fs/f2fs/inode.c          |   2 +-
 fs/f2fs/namei.c          |  10 ++--
 fs/f2fs/super.c          |   2 +-
 include/linux/fscrypto.h |  81 +++++++++++++++++++++--------
 11 files changed, 236 insertions(+), 154 deletions(-)

-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
