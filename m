From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix missing unlock on error in collapse range
Date: Tue, 27 May 2014 12:48:20 -0400
Message-ID: <20140527164820.GC1158@thunk.org>
References: <000601cf793f$e5377070$afa65150$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Dan Carpenter' <dan.carpenter@oracle.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35163 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbaE0QsZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2014 12:48:25 -0400
Content-Disposition: inline
In-Reply-To: <000601cf793f$e5377070$afa65150$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 27, 2014 at 09:09:15AM +0900, Namjae Jeon wrote:
> Add i_write_mutex unlock on the error handling path in collapse_range().
> 
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  fs/ext4/extents.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Thanks for the patch!

This is the increment diff which I'm going to apply instead.  It
results in a net decrease of one line of code, instead of a net
increase of two, and it is more consistent in terms of the error
handling style.

Cheers,

					- Ted

 fs/ext4/extents.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8ffab40..cb23a34 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5423,10 +5423,8 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	/* Call ext4_force_commit to flush all data in case of data=journal. */
 	if (ext4_should_journal_data(inode)) {
 		ret = ext4_force_commit(inode->i_sb);
-		if (ret) {
-			mutex_unlock(&EXT4_I(inode)->i_write_mutex);
-			return ret;
-		}
+		if (ret)
+			goto out_i_write_mutex;
 	}
 
 	/*
@@ -5439,7 +5437,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
 					   LLONG_MAX);
 	if (ret)
-		return ret;
+		goto out_i_write_mutex;
 
 	/* Take mutex lock */
 	mutex_lock(&inode->i_mutex);
@@ -5512,6 +5510,7 @@ out_dio:
 	ext4_inode_resume_unlocked_dio(inode);
 out_mutex:
 	mutex_unlock(&inode->i_mutex);
+out_i_write_mutex:
 	mutex_unlock(&EXT4_I(inode)->i_write_mutex);
 	return ret;
 }
