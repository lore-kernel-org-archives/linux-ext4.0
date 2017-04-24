From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 0/6] fscrypt: fixes for presentation of long
	encrypted filenames
Date: Mon, 24 Apr 2017 10:00:07 -0700
Message-ID: <20170424170013.85175-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: hashimoto@chromium.org, Gwendal Grignou <gwendal@chromium.org>,
	"Theodore Y . Ts'o" <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-ext4@vger.kernel.org, kinaba@chromium.org
To: linux-fscrypt@vger.kernel.org
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

From: Eric Biggers <ebiggers@google.com>

This series fixes the bugs that have been identified with how filesystems handle
presenting long encrypted filenames without the key.

Patch 1 is Jaegeuk's fix to make f2fs start checking the ciphertext portion of
the digested names.  I made one change to this patch which is that to determine
whether we should use the hash from the fscrypt_name structure rather than
compute the hash, we should check for 'disk_name.name' being NULL rather than
'hash' being nonzero, since 0 is a valid hash value.

Patch 2 fixes the bug found on Chrome OS where the wrong part of the ciphertext
was included in the digested names, causing collisions and undeletable files.

Patches 3-6 clean things up to be less insane and confusing, e.g. by introducing
a shared function for name matching and a struct to represent a digested name.

Patches 1-2 will need to be backported and I think they should be merged into
4.12 through the fscrypt tree.  The other patches are nice to have but it's not
a big deal if they need to wait for next cycle.

This patch series leaves out UBIFS; it can be changed to use the common matching
function once available, if desired.

Eric Biggers (5):
  fscrypt: avoid collisions when presenting long encrypted filenames
  fscrypt: introduce helper function for filename matching
  ext4: switch to using fscrypt_match_name()
  f2fs: switch to using fscrypt_match_name()
  ext4: clean up ext4_match() and callers

Jaegeuk Kim (1):
  f2fs: check entire encrypted bigname when finding a dentry

 fs/crypto/fname.c               |  90 +++++++++++++++++++++++++++--------
 fs/crypto/fscrypt_private.h     |   2 -
 fs/ext4/namei.c                 | 103 ++++++++++++----------------------------
 fs/f2fs/dir.c                   |  25 ++--------
 fs/f2fs/f2fs.h                  |   3 +-
 fs/f2fs/hash.c                  |   7 ++-
 fs/f2fs/inline.c                |   4 +-
 include/linux/fscrypt_notsupp.h |   9 ++++
 include/linux/fscrypt_supp.h    |  78 ++++++++++++++++++++++++++++++
 9 files changed, 202 insertions(+), 119 deletions(-)

-- 
2.12.2.816.g2cccc81164-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
