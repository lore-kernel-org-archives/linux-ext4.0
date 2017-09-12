From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 3/5] ext4: add sanity check for encryption + DAX
Date: Mon, 11 Sep 2017 23:05:24 -0600
Message-ID: <20170912050526.7627-4-ross.zwisler@linux.intel.com>
References: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170912050526.7627-1-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

We prevent DAX from being used on inodes which are using ext4's built in
encryption via a check in ext4_set_inode_flags().  We do have what appears
to be an unsafe transition of S_DAX in ext4_set_context(), though, where
S_DAX can get disabled without us doing a proper writeback + invalidate.

There are also issues with mm-level races when changing the value of S_DAX,
as well as issues with the VM_MIXEDMAP flag:

https://www.spinics.net/lists/linux-xfs/msg09859.html

I actually think we are safe in this case because of the following:

1) You can't encrypt an existing file.  Encryption can only be set on an
empty directory, with new inodes in that directory being created with
encryption turned on, so I don't think it's possible to turn encryption on
for a file that has open DAX mmaps or outstanding I/Os.

2) There is no way to turn encryption off on a given file.  Once an inode
is encrypted, it stays encrypted for the life of that inode, so we don't
have to worry about the case where we turn encryption off and S_DAX
suddenly turns on.

3) The only way we end up in ext4_set_context() to turn on encryption is
when we are creating a new file in the encrypted directory.  This happens
as part of ext4_create() before the inode has been allowed to do any I/O.
Here's the call tree:

 ext4_create()
   __ext4_new_inode()
	 ext4_set_inode_flags() // sets S_DAX
	 fscrypt_inherit_context()
		fscrypt_get_encryption_info();
		ext4_set_context() // sets EXT4_INODE_ENCRYPT, clears S_DAX

So, I actually think it's safe to transition S_DAX in ext4_set_context()
without any locking, writebacks or invalidations.  I've added a
WARN_ON_ONCE() sanity check to make sure that we are notified if we ever
encounter a case where we are encrypting an inode that already has data,
in which case we need to add code to safely transition S_DAX.

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
CC: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/ext4/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4251e50..c090780 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1159,6 +1159,9 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	if (inode->i_ino == EXT4_ROOT_INO)
 		return -EPERM;
 
+	if (WARN_ON_ONCE(IS_DAX(inode) && i_size_read(inode)))
+		return -EINVAL;
+
 	res = ext4_convert_inline_data(inode);
 	if (res)
 		return res;
-- 
2.9.5
