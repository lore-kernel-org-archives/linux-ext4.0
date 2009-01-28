From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH] : Remove incompatible pointer assignment warning in ext4
	quota operations
Date: Wed, 28 Jan 2009 10:51:39 +0530
Message-ID: <ea11fea30901272121x319aa2b3m2a5a5799b6df4d8a@mail.gmail.com>
References: <ea11fea30901272117j760a34e8w5df0ec1916632f3f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:30656 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbZA1FVl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Jan 2009 00:21:41 -0500
Received: by ti-out-0910.google.com with SMTP id b6so3429141tic.23
        for <linux-ext4@vger.kernel.org>; Tue, 27 Jan 2009 21:21:39 -0800 (PST)
In-Reply-To: <ea11fea30901272117j760a34e8w5df0ec1916632f3f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 28, 2009 at 10:47 AM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> Below patch removes the following warning during compilation :
>
>  CC [M]  fs/ext4/super.o
> fs/ext4/super.c:949: warning: initialization from incompatible pointer type
>  LD [M]  fs/ext4/ext4.o

Sorry,

Tha correct patch is here.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/ext4.h  |    2 +-
 fs/ext4/inode.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3ab1a41..0164866 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1088,7 +1088,7 @@ extern int ext4_chunk_trans_blocks(struct inode
*, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
-extern unsigned long long ext4_get_reserved_space(struct inode *inode);
+extern qsize_t ext4_get_reserved_space(struct inode *inode);

 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6a316ec..6be09be 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -973,9 +973,9 @@ out:
 	return err;
 }

-unsigned long long ext4_get_reserved_space(struct inode *inode)
+qsize_t ext4_get_reserved_space(struct inode *inode)
 {
-	unsigned long long total;
+	qsize_t total;

 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	total = EXT4_I(inode)->i_reserved_data_blocks +
-- 
1.5.4.3

Thanks -
Manish

>
>
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/ext4/ext4.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3ab1a41..0164866 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1088,7 +1088,7 @@ extern int ext4_chunk_trans_blocks(struct inode
> *, int nrblocks);
>  extern int ext4_block_truncate_page(handle_t *handle,
>                struct address_space *mapping, loff_t from);
>  extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
> -extern unsigned long long ext4_get_reserved_space(struct inode *inode);
> +extern qsize_t ext4_get_reserved_space(struct inode *inode);
>
>  /* ioctl.c */
>  extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
> --
> 1.5.4.3
>
>
> Thanks -
> Manish
>
