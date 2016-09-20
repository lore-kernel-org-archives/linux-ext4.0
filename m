From: Richard Weinberger <richard@nod.at>
Subject: Locking rules for fscrypt_operations->set_context()
Date: Tue, 20 Sep 2016 16:30:06 +0200
Message-ID: <b6073ec6-3826-a4a1-b1ce-48106c012d43@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Theodore Ts'o <tytso@mit.edu>, David Gstir <david@sigma-star.at>
To: linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

To my understanding ->setxattr() is always being called with i_mutex held.
->set_context() in ext4 stores the security context using ext4_xattr_set(),
but the fs crypto framework does not lock the inode itself.
So, depending on the call path, ext4_xattr_set() is sometimes being
called with i_mutex held and some times not.

What are the locking rules for fscrypt_operations and especially ->set_context()?

Thanks,
//richard
