From: Richard Weinberger <richard@nod.at>
Subject: fscrypt: Howto resolve hash collisions?
Date: Wed, 5 Oct 2016 16:00:36 +0200
Message-ID: <859a9544-fe9d-4656-7b45-b25719c8eadc@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

UBIFS uses the r5 hash algorithm for filenames and is able to resolve hash collisions.
Unless I miss something it is not possible to resolve hash collisions for bignames
in fscrypto.

UBIFS does in readdir():
fscrypt_fname_disk_to_usr(dir, key_hash_flash(c, &dent->key), 0, &nm.disk_name, &fstr);

Hence, it feeds its filename hash to fscrypto and when no key is present fscrypto
encodes that hash into a bigname starting with "_".
minor_hash is not set because UBIFS's hash has only 32bits.

Upon lookup UBIFS does:
fscrypt_setup_filename(dir, &dentry->d_name, 1, &nm);

For small names nm will contain the decoded name, UBIFS will compute the r5 hash,
does a lookup and compares whether the found directory entry matches the name.
It not, it will resolve the collision.
On the other hand, with bignames, nm will only contain hash and minor_hash.
UBIFS can do a lookup based on the hash value but it has no way to detect nor resolve
the collision since no name is present.

What do I miss? Are ext4 and f2fs not able to resolve hash collisions and therefore
nobody noticed?

Thanks,
//richard
