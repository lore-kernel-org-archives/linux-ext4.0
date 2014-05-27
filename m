From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: serialize unaligned asynchronous DIO
Date: Tue, 27 May 2014 11:38:08 -0400
Message-ID: <20140527153808.GA1158@thunk.org>
References: <20140527141708.GA2842@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namjae Jeon <namjae.jeon@samsung.com>, linux-ext4@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35007 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbaE0PiP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2014 11:38:15 -0400
Content-Disposition: inline
In-Reply-To: <20140527141708.GA2842@mwanda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 27, 2014 at 05:17:08PM +0300, Dan Carpenter wrote:
> Hello Namjae Jeon,
> 
> The patch 00532604c72e: "ext4: introduce new i_write_mutex to protect
> fallocate" from May 26, 2014, leads to the following static checker
> warning:

Thanks, already fixed with the following incremental patch.

		      	       		 	     - Ted

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 8c39305..e5cd87f 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -135,8 +135,8 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 		if ((pos > sbi->s_bitmap_maxbytes) ||
 		    (pos == sbi->s_bitmap_maxbytes && length > 0)) {
 			mutex_unlock(&inode->i_mutex);
-			ret = -EFBIG;
-			goto errout;
+			mutex_unlock(&EXT4_I(inode)->i_write_mutex);
+			return -EFBIG;
 		}
 
 		if (pos + length > sbi->s_bitmap_maxbytes) {
@@ -196,7 +196,6 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 	if (o_direct)
 		blk_finish_plug(&plug);
 
-errout:
 	if (unaligned_direct_aio)
 		mutex_unlock(&EXT4_I(inode)->i_write_mutex);
 	return ret;


