From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypt / ext4: make test_dummy_encryption require a
 keyring key
Date: Thu, 5 Jan 2017 10:10:59 -0500
Message-ID: <20170105151059.egz6an7wfirygdr6@thunk.org>
References: <1481611930-65173-1-git-send-email-ebiggers3@gmail.com>
 <20170102204342.vib5ayse4kthruma@thunk.org>
 <20170105001606.GC21696@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-fsdevel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170105001606.GC21696@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 04, 2017 at 04:16:06PM -0800, Eric Biggers wrote:
> I'm fine with your proposed version, though I'm not convinced it's really any
> better than mine, since it basically just moves the "hack" from
> fscrypt_inherit_context() to fscrypt_get_encryption_info().  The reason I
> preferred it in fscrypt_inherit_context() was that allowing
> fscrypt_get_encryption_info() to work on unencrypted files is kind of weird and
> could allow for confusing scenarios where a previously existing unencrypted file
> is accidentally treated as an encrypted one --- though that would require a
> missing ext4_encrypted_inode() check of course.

Except that you *always* need to call ext4_encrypt_inode() before you
call fscrypt_get_encryption_info(), because otherwise it becomes a
performance disaster in the no encryption case, because we would be
constantly doing failing xattr lookups.

It also made for some especially tangled logic, which I noticed when
you had to make a change in fs/ext4/namei.c:

        if ((ext4_encrypted_inode(dir) ||  <-----------------------
             DUMMY_ENCRYPTION_ENABLED(EXT4_SB(dir->i_sb))) &&
            (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))) {
-               err = fscrypt_get_encryption_info(dir);
-               if (err)
-                       return ERR_PTR(err);
-               if (!fscrypt_has_encryption_key(dir))
-                       return ERR_PTR(-EPERM);
+               if (ext4_encrypted_inode(dir)) {   <-------------------
+                       err = fscrypt_get_encryption_info(dir);
+                       if (err)
+                               return ERR_PTR(err);
+                       if (!fscrypt_has_encryption_key(dir))
+                               return ERR_PTR(-EPERM);
+               }
                if (!handle)


Your patch required the addition of a *second* call to
ext4_encrypted_inode() or else the call to
fscrypt_get_encryption_info() would fail in the test_dummy_encryption
case.

Not having hacks in the fscrypt_inherit_context() case also has the
happy advantage that we test the normal context inheritance code path
when creating files in the (unencrypted) root directory.

						- Ted
