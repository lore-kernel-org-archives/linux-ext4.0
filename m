From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] export iov_shorten for ext4's use
Date: Mon, 17 Dec 2007 09:14:22 -0600
Message-ID: <4766924E.9000908@redhat.com>
References: <4762C470.8040003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbXLQPO3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Dec 2007 10:14:29 -0500
In-Reply-To: <4762C470.8040003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(And, take 2... follow the coding style on export declarations...)

ext4 needs to deal with 2 different max file offsets for block- and 
extent-allocated file formats, whereas the s_maxbytes scheme can only deal 
with one.  So, for block-allocated files, we must catch and fix up
too-large offsets from within the filesystem.

Having iov_shorten exported allows such things as:

		if (pos + length > sbi->s_bitmap_maxbytes) {
			nr_segs = iov_shorten((struct iovec *)iov, nr_segs,
					      sbi->s_bitmap_maxbytes - pos);
		}

to fix up too-large writes to these files in ext4_file_write().

This patch is currently living in the ext4 patch queue.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---


Index: linux-2.6.24-rc3/fs/read_write.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/read_write.c
+++ linux-2.6.24-rc3/fs/read_write.c
@@ -450,6 +450,7 @@ unsigned long iov_shorten(struct iovec *
 	}
 	return seg;
 }
+EXPORT_SYMBOL(iov_shorten)
 
 ssize_t do_sync_readv_writev(struct file *filp, const struct iovec *iov,
 		unsigned long nr_segs, size_t len, loff_t *ppos, iov_fn_t fn)
