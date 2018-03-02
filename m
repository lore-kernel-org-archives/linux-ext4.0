From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 4.1 1/3] ext4: require encryption feature for EXT4_IOC_SET_ENCRYPTION_POLICY
Date: Fri,  2 Mar 2018 14:21:11 -0800
Message-ID: <20180302222113.85389-2-ebiggers3@gmail.com>
References: <20180302222113.85389-1-ebiggers3@gmail.com>
Cc: linux-ext4@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>
To: stable@vger.kernel.org, Sasha Levin <Alexander.Levin@microsoft.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180302222113.85389-1-ebiggers3@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Richard Weinberger <richard@nod.at>

commit 9a200d075e5d05be1fcad4547a0f8aee4e2f9a04 upstream.

...otherwise an user can enable encryption for certain files even
when the filesystem is unable to support it.
Such a case would be a filesystem created by mkfs.ext4's default
settings, 1KiB block size. Ext4 supports encyption only when block size
is equal to PAGE_SIZE.
But this constraint is only checked when the encryption feature flag
is set.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 4196aa567784..dbe1ff511794 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -630,6 +630,9 @@ resizefs_out:
 		struct ext4_encryption_policy policy;
 		int err = 0;
 
+		if (!ext4_sb_has_crypto(sb))
+			return -EOPNOTSUPP;
+
 		if (copy_from_user(&policy,
 				   (struct ext4_encryption_policy __user *)arg,
 				   sizeof(policy))) {
-- 
2.16.2.395.g2e18187dfd-goog
