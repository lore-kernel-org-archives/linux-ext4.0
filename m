From: Michael Halcrow <mhalcrow@google.com>
Subject: [PATCH 0/5] ext4: RFC: Encryption
Date: Wed, 23 Jul 2014 14:23:23 -0700
Message-ID: <1406150608-19351-1-git-send-email-mhalcrow@google.com>
Cc: zohar@linux.vnet.ibm.com, mhalcrow@google.com,
	herbert@gondor.apana.org.au, pavel@ucw.cz, hch@infradead.org,
	lczerner@redhat.com, tytso@mit.edu, tyhicks@canonical.com,
	serge.hallyn@canonical.com
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patchset proposes a method for encrypting in EXT4 data read and
write paths. It's a proof-of-concept/prototype only right
now. Outstanding issues:

 * While it seems to work well with complex tasks like a parallel
   kernel build, fsx is pretty good at reliably breaking it in its
   current form. I think it's trying to decrypt a page of all zeros
   when doing a mmap'd write after an falloc. I want to get feedback
   on the overall approach before I spend too much time bug-hunting.

 * It has not undergone a security audit/review. It isn't IND-CCA2
   secure, and that's the goal. We need a way to store (at least)
   page-granular metadata.

 * Only the file data is encrypted. I'd like to look into also
   encrypting the file system metadata with a mount-wide key. That's
   for another phase of development.

 * The key management isn't fleshed out. I've hacked in some eCryptfs
   stuff because it was the fastest way for me to stand up the
   prototype with real crypto keys. Use ecryptfs-add-passphrase to add
   a key to the keyring, and then pass the hex sig as the
   encrypt_key_sig mount option:

# apt-get install ecryptfs-utils
# echo -n "hunter2" | ecryptfs-add-passphrase 
Passphrase: 
Inserted auth tok with sig [4cb927ea0c564410] into the user session keyring
# mount -o encrypt_key_sig=4cb927ea0c564410 /dev/sdb1 /mnt/ext4crypt

 * The EXT4 block size must be the same as the page size. I'm not yet
   sure whether I will want to try to support block-granular
   encryption or page-granular encryption. There are implications with
   respect to how much the integrity data occupies in relation to the
   encrypted data.

Mimi, maybe an approach like this one will work out for IMA. We've
just got to figure out where to store the block- or page-granular
integrity data.

I've broken up the patches so that not only can each one build after
application, but discrete steps of functionality can be tested one
patch at a time.

A couple of other thoughts:

 * Maybe the write submit path can complete on the encryption
   callback. Not sure what that might buy us.

 * Maybe a key with a specific descriptor in each user's keyring
   (e.g. "EXT4_DEFAULT_KEY") can be used when creating new files so
   that each user can use his own key in a common EXT4 mount. Or maybe
   we can specify an encryption context in the parent directory xattr.

Michael Halcrow (5):
  ext4: Adds callback support for bio read completion
  ext4: Adds EXT4 encryption facilities
  ext4: Implements the EXT4 encryption write path
  ext4: Adds EXT4 encryption read callback support
  ext4: Implements real encryption in the EXT4 write and read paths

 fs/buffer.c                 |  46 +++-
 fs/ext4/Makefile            |   9 +-
 fs/ext4/crypto.c            | 629 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h              |  50 ++++
 fs/ext4/file.c              |   9 +-
 fs/ext4/inode.c             | 196 +++++++++++++-
 fs/ext4/namei.c             |   3 +
 fs/ext4/page-io.c           | 182 ++++++++++---
 fs/ext4/super.c             |  34 ++-
 fs/ext4/xattr.h             |   1 +
 include/linux/bio.h         |   3 +
 include/linux/blk_types.h   |   4 +
 include/linux/buffer_head.h |   8 +
 13 files changed, 1118 insertions(+), 56 deletions(-)
 create mode 100644 fs/ext4/crypto.c

-- 
2.0.0.526.g5318336

