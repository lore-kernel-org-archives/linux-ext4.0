From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] fs: Convert return type int to vm_fault_t
Date: Thu, 30 Aug 2018 16:35:21 -0700
Message-ID: <20180830163521.728f3ff2fd3cc93b52a5dcc0@linux-foundation.org>
References: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: konishi.ryusuke@lab.ntt.co.jp, viro@zeniv.linux.org.uk,
        tytso@mit.edu, adilger.kernel@dilger.ca, axboe@kernel.dk,
        darrick.wong@oracle.com, ebiggers@google.com, pombredanne@nexb.com,
        agruenba@redhat.com, gregkh@linuxfoundation.org,
        kemi.wang@intel.com, willy@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nilfs@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 30 Aug 2018 22:55:47 +0530 Souptick Joarder <jrdr.linux@gmail.com> wrote:

> Return type for fault handlers  in ext4 and nilfs are
> changed to use vm_fault_t.
> 
> Return type of block_page_mkwrite() is changed from
> int to vm_fault_t. The function signature of
> block_page_mkwrite() is changed to add one new parameter
> int *err. This will provide a way for caller functions
> to get error value along with return value and use it
> further.
> 
> Return type of block_page_mkwrite_return() is also changed
> to use new vm_fault_t type.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> ---
> v2: return type of nilfs_page_mkwrite() changed to vm_fault_t
>     Address Ryusuke's comment. remove err =0.

The v1->v2 delta (below) reveals unchangelogged ext4 changes?

--- a/fs/ext4/inode.c~fs-convert-return-type-int-to-vm_fault_t-v2
+++ a/fs/ext4/inode.c
@@ -6174,14 +6174,13 @@ vm_fault_t ext4_page_mkwrite(struct vm_f
 	if (err)
 		goto out_ret;
 
-	err = 0;
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
 	    !ext4_should_journal_data(inode) &&
 	    !ext4_nonda_switch(inode->i_sb)) {
 		do {
 			ret = block_page_mkwrite(vma, vmf,
-					ext4_da_get_block_prep, &err);
+						ext4_da_get_block_prep, &err);
 		} while (err == -ENOSPC &&
 		       ext4_should_retry_alloc(inode->i_sb, &retries));
 		goto out;
@@ -6227,7 +6226,6 @@ retry_alloc:
 		ret = VM_FAULT_SIGBUS;
 		goto out;
 	}
-	err = 0;
 	ret = block_page_mkwrite(vma, vmf, get_block, &err);
 	if (!ret && ext4_should_journal_data(inode)) {
 		if (ext4_walk_page_buffers(handle, page_buffers(page), 0,
@@ -6239,8 +6237,7 @@ retry_alloc:
 		ext4_set_inode_state(inode, EXT4_STATE_JDATA);
 	}
 	ext4_journal_stop(handle);
-	if (err == -ENOSPC &&
-		ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (err == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry_alloc;
 out_ret:
 	ret = block_page_mkwrite_return(err);
--- a/fs/nilfs2/file.c~fs-convert-return-type-int-to-vm_fault_t-v2
+++ a/fs/nilfs2/file.c
@@ -107,7 +107,6 @@ static vm_fault_t nilfs_page_mkwrite(str
 		goto out;
 	}
 
-	err = 0;
 	file_update_time(vma->vm_file);
 	ret = block_page_mkwrite(vma, vmf, nilfs_get_block, &err);
 	if (ret) {
_
