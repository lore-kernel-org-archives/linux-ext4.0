From: Richard Weinberger <richard@nod.at>
Subject: ext4, f2fs: fscrypt_has_permitted_context() check in file open
Date: Thu, 22 Sep 2016 14:24:35 +0200
Message-ID: <6789d30e-f95d-d8bd-cd6e-664a89c0dfd1@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

Both ext4 and f2fs check in the file open code the context of the parent directory too:

ext4:
        if (ext4_encrypted_inode(d_inode(dir)) &&
                        !fscrypt_has_permitted_context(d_inode(dir), inode)) {
                ext4_warning(inode->i_sb,
                             "Inconsistent encryption contexts: %lu/%lu",
                             (unsigned long) d_inode(dir)->i_ino,
                             (unsigned long) inode->i_ino);
                dput(dir);
                return -EPERM;
        }

f2fs:
        if (f2fs_encrypted_inode(d_inode(dir)) &&
                        !fscrypt_has_permitted_context(d_inode(dir), inode)) {
                dput(dir);
                return -EPERM;
        }

Why do we need this check? AFAIK this situation can never happen unless due to
a bug in the filesystem code.

Thanks,
//richard
