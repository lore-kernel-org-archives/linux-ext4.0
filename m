From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
	features in larger inode
Date: Mon, 16 Jul 2007 16:52:03 -0700
Message-ID: <1184629924.3836.5.camel@localhost.localdomain>
References: <1183275482.4010.133.camel@localhost.localdomain>
	 <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
	 <20070713020529.1486491f.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46435 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761598AbXGPXwD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2007 19:52:03 -0400
In-Reply-To: <20070713020529.1486491f.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-07-13 at 02:05 -0700, Andrew Morton wrote:
> On Tue, 10 Jul 2007 16:32:47 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > +	brelse(bh);
> > > +	up_write(&EXT4_I(inode)->xattr_sem);
> > > +	return error;
> > > +}
> > > +
> > 
> > We're doing GFP_KERNEL memory allocations while holding xattr_sem.  This
> > can cause the VM to reenter the filesystem, perhaps taking i_mutex and/or
> > i_truncate_sem and/or journal_start() (I forget whether this still
> > happens).  Have we checked whether this can occur and if so, whether we are
> > OK from a lock ranking POV?  Bear in mind that journalled-data mode is more
> > complex in this regard.
> 
> I notice that everyone carefully avoided addressing this ;)

I am not sure why we need GFP_KERNEL flag here. I think we should use
GFP_NOFS instead. The following patch use the GFP_NOFS flag, as well as
fixing memory leak issue introduced by the ext4 expand inode extra isize
patch.

Fixing memory allocation issue with expand inode extra isize patch.

- use GFP_NOFS instead of GFP_KERNEL flag for memory allocation
- use kzalloc instead of kmalloc
- fix memory leak in the success case, at the end of while loop.


Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/xattr.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6.22/fs/ext4/xattr.c
===================================================================
--- linux-2.6.22.orig/fs/ext4/xattr.c	2007-07-16 16:12:18.000000000 -0700
+++ linux-2.6.22/fs/ext4/xattr.c	2007-07-16 16:35:59.000000000 -0700
@@ -1204,8 +1204,8 @@ retry:
 		unsigned int shift_bytes; /* No. of bytes to shift EAs by? */
 		unsigned int min_total_size = ~0U;
 
-		is = kzalloc(sizeof(struct ext4_xattr_ibody_find), GFP_KERNEL);
-		bs = kzalloc(sizeof(struct ext4_xattr_block_find), GFP_KERNEL);
+		is = kzalloc(sizeof(struct ext4_xattr_ibody_find), GFP_NOFS);
+		bs = kzalloc(sizeof(struct ext4_xattr_block_find), GFP_NOFS);
 		if (!is || !bs) {
 			error = -ENOMEM;
 			goto cleanup;
@@ -1251,8 +1251,8 @@ retry:
 		size = le32_to_cpu(entry->e_value_size);
 		entry_size = EXT4_XATTR_LEN(entry->e_name_len);
 		i.name_index = entry->e_name_index,
-		buffer = kmalloc(EXT4_XATTR_SIZE(size), GFP_KERNEL);
-		b_entry_name = kmalloc(entry->e_name_len + 1, GFP_KERNEL);
+		buffer = kzalloc(EXT4_XATTR_SIZE(size), GFP_NOFS);
+		b_entry_name = kzalloc(entry->e_name_len + 1, GFP_NOFS);
 		if (!buffer || !b_entry_name) {
 			error = -ENOMEM;
 			goto cleanup;
@@ -1302,7 +1302,15 @@ retry:
 		error = ext4_xattr_block_set(handle, inode, &i, bs);
 		if (error)
 			goto cleanup;
+		kfree(b_entry_name);
+		kfree(buffer);
+		brelse(is->iloc.bh);
+		kfree(is);
+		kfree(bs);
+		brelse(bh);
 	}
+	up_write(&EXT4_I(inode)->xattr_sem);
+        return 0;
 
 cleanup:
 	kfree(b_entry_name);
