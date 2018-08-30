From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] fs: Convert return type int to vm_fault_t
Date: Thu, 30 Aug 2018 22:08:41 +0530
Message-ID: <CAFqt6zbtnNPCezFgc72ZDib29uDCK=hLO_qPDt1QD1nVqXEPCw@mail.gmail.com>
References: <20180828192528.GA24453@jordon-HP-15-Notebook-PC> <20180830.165629.1747893038794269821.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Eric Biggers <ebiggers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>, kemi.wang@intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nilfs <linux-nilfs@vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830.165629.1747893038794269821.konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 30, 2018 at 1:26 PM Ryusuke Konishi
<konishi.ryusuke@lab.ntt.co.jp> wrote:
>
> Hi,
>
> On Wed, 29 Aug 2018 00:55:28 +0530, Souptick Joarder wrote:
> > Return type for fault handlers  in ext4 and nilfs are
> > changed to use vm_fault_t.
> >
> > Return type of block_page_mkwrite() is changed from
> > int to vm_fault_t. The function signature of
> > block_page_mkwrite() is changed to add one new parameter
> > int *err. This will provide a way for caller functions
> > to get error number along with VM_FAULT return value and
> > use it further.
> >
> > Return type of block_page_mkwrite_return() is also changed
> > to use new vm_fault_t type.
> >
> > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> > ---
> >  fs/buffer.c                 | 20 +++++++++++---------
> >  fs/ext4/ext4.h              |  4 ++--
> >  fs/ext4/inode.c             | 34 ++++++++++++++++++----------------
> >  fs/nilfs2/file.c            | 16 ++++++++++------
> >  include/linux/buffer_head.h |  7 ++++---
> >  5 files changed, 45 insertions(+), 36 deletions(-)
> >
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index ebf78ab..aacfc73 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -2487,21 +2487,21 @@ int block_commit_write(struct page *page, unsigned from, unsigned to)
> >   * Direct callers of this function should protect against filesystem freezing
> >   * using sb_start_pagefault() - sb_end_pagefault() functions.
> >   */
> > -int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> > -                      get_block_t get_block)
> > +vm_fault_t block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> > +                      get_block_t get_block, int *err)
> >  {
> >       struct page *page = vmf->page;
> >       struct inode *inode = file_inode(vma->vm_file);
> >       unsigned long end;
> >       loff_t size;
> > -     int ret;
> > +     int err1;
> >
> >       lock_page(page);
> >       size = i_size_read(inode);
> >       if ((page->mapping != inode->i_mapping) ||
> >           (page_offset(page) > size)) {
> >               /* We overload EFAULT to mean page got truncated */
> > -             ret = -EFAULT;
> > +             err1 = -EFAULT;
> >               goto out_unlock;
> >       }
> >
> > @@ -2511,18 +2511,20 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> >       else
> >               end = PAGE_SIZE;
> >
> > -     ret = __block_write_begin(page, 0, end, get_block);
> > -     if (!ret)
> > -             ret = block_commit_write(page, 0, end);
> > +     err1 = __block_write_begin(page, 0, end, get_block);
> > +     if (!err1)
> > +             err1 = block_commit_write(page, 0, end);
> >
> > -     if (unlikely(ret < 0))
> > +     if (unlikely(err1 < 0))
> >               goto out_unlock;
> > +     *err = err1;
> >       set_page_dirty(page);
> >       wait_for_stable_page(page);
> >       return 0;
> >  out_unlock:
> >       unlock_page(page);
> > -     return ret;
> > +     *err = err1;
> > +     return block_page_mkwrite_return(err1);
> >  }
> >  EXPORT_SYMBOL(block_page_mkwrite);
> >
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 0f0edd1..8506b14 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -2469,8 +2469,8 @@ int do_journal_get_write_access(handle_t *handle,
> >  extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
> >  extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
> >                            loff_t lstart, loff_t lend);
> > -extern int ext4_page_mkwrite(struct vm_fault *vmf);
> > -extern int ext4_filemap_fault(struct vm_fault *vmf);
> > +extern vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf);
> > +extern vm_fault_t ext4_filemap_fault(struct vm_fault *vmf);
> >  extern qsize_t *ext4_get_reserved_space(struct inode *inode);
> >  extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
> >  extern void ext4_da_update_reserve_space(struct inode *inode,
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 82adee7..1062a8e 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -6151,39 +6151,40 @@ static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
> >       return !buffer_mapped(bh);
> >  }
> >
> > -int ext4_page_mkwrite(struct vm_fault *vmf)
> > +vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
> >  {
> >       struct vm_area_struct *vma = vmf->vma;
> >       struct page *page = vmf->page;
> >       loff_t size;
> >       unsigned long len;
> > -     int ret;
> > +     vm_fault_t ret;
> >       struct file *file = vma->vm_file;
> >       struct inode *inode = file_inode(file);
> >       struct address_space *mapping = inode->i_mapping;
> >       handle_t *handle;
> >       get_block_t *get_block;
> > -     int retries = 0;
> > +     int retries = 0, err;
> >
> >       sb_start_pagefault(inode->i_sb);
> >       file_update_time(vma->vm_file);
> >
> >       down_read(&EXT4_I(inode)->i_mmap_sem);
> >
> > -     ret = ext4_convert_inline_data(inode);
> > -     if (ret)
> > +     err = ext4_convert_inline_data(inode);
> > +     if (err)
> >               goto out_ret;
> >
> > +     err = 0;
> >       /* Delalloc case is easy... */
> >       if (test_opt(inode->i_sb, DELALLOC) &&
> >           !ext4_should_journal_data(inode) &&
> >           !ext4_nonda_switch(inode->i_sb)) {
> >               do {
> >                       ret = block_page_mkwrite(vma, vmf,
> > -                                                ext4_da_get_block_prep);
> > -             } while (ret == -ENOSPC &&
> > +                                     ext4_da_get_block_prep, &err);
> > +             } while (err == -ENOSPC &&
> >                      ext4_should_retry_alloc(inode->i_sb, &retries));
> > -             goto out_ret;
> > +             goto out;
> >       }
> >
> >       lock_page(page);
> > @@ -6226,36 +6227,37 @@ int ext4_page_mkwrite(struct vm_fault *vmf)
> >               ret = VM_FAULT_SIGBUS;
> >               goto out;
> >       }
> > -     ret = block_page_mkwrite(vma, vmf, get_block);
> > +     err = 0;
> > +     ret = block_page_mkwrite(vma, vmf, get_block, &err);
> >       if (!ret && ext4_should_journal_data(inode)) {
> >               if (ext4_walk_page_buffers(handle, page_buffers(page), 0,
> >                         PAGE_SIZE, NULL, do_journal_get_write_access)) {
> >                       unlock_page(page);
> > -                     ret = VM_FAULT_SIGBUS;
> >                       ext4_journal_stop(handle);
> >                       goto out;
> >               }
> >               ext4_set_inode_state(inode, EXT4_STATE_JDATA);
> >       }
> >       ext4_journal_stop(handle);
> > -     if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> > +     if (err == -ENOSPC &&
> > +             ext4_should_retry_alloc(inode->i_sb, &retries))
> >               goto retry_alloc;
> >  out_ret:
> > -     ret = block_page_mkwrite_return(ret);
> > +     ret = block_page_mkwrite_return(err);
> >  out:
> >       up_read(&EXT4_I(inode)->i_mmap_sem);
> >       sb_end_pagefault(inode->i_sb);
> >       return ret;
> >  }
> >
> > -int ext4_filemap_fault(struct vm_fault *vmf)
> > +vm_fault_t ext4_filemap_fault(struct vm_fault *vmf)
> >  {
> >       struct inode *inode = file_inode(vmf->vma->vm_file);
> > -     int err;
> > +     vm_fault_t ret;
> >
> >       down_read(&EXT4_I(inode)->i_mmap_sem);
> > -     err = filemap_fault(vmf);
> > +     ret = filemap_fault(vmf);
> >       up_read(&EXT4_I(inode)->i_mmap_sem);
> >
> > -     return err;
> > +     return ret;
> >  }
> > diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> > index 7da0fac..58d2a81 100644
> > --- a/fs/nilfs2/file.c
> > +++ b/fs/nilfs2/file.c
> > @@ -57,7 +57,8 @@ static vm_fault_t nilfs_page_mkwrite(struct vm_fault *vmf)
> >       struct page *page = vmf->page;
> >       struct inode *inode = file_inode(vma->vm_file);
> >       struct nilfs_transaction_info ti;
> > -     int ret = 0;
> > +     vm_fault_t ret = VM_FAULT_LOCKED;
> > +     int err = 0;
> >
> >       if (unlikely(nilfs_near_disk_full(inode->i_sb->s_fs_info)))
> >               return VM_FAULT_SIGBUS; /* -ENOSPC */
> > @@ -67,7 +68,7 @@ static vm_fault_t nilfs_page_mkwrite(struct vm_fault *vmf)
> >       if (page->mapping != inode->i_mapping ||
> >           page_offset(page) >= i_size_read(inode) || !PageUptodate(page)) {
> >               unlock_page(page);
> > -             ret = -EFAULT;  /* make the VM retry the fault */
> > +             ret = VM_FAULT_NOPAGE;  /* make the VM retry the fault */
> >               goto out;
> >       }
> >
> > @@ -99,13 +100,16 @@ static vm_fault_t nilfs_page_mkwrite(struct vm_fault *vmf)
> >       /*
> >        * fill hole blocks
> >        */
> > -     ret = nilfs_transaction_begin(inode->i_sb, &ti, 1);
> > +     err = nilfs_transaction_begin(inode->i_sb, &ti, 1);
> >       /* never returns -ENOMEM, but may return -ENOSPC */
> > -     if (unlikely(ret))
> > +     if (unlikely(err)) {
> > +             ret = block_page_mkwrite_return(err);
> >               goto out;
> > +     }
> >
>
> > +     err = 0;
>
> This initialization looks unnecessary.  "err" is always zero here.

Agree.
>
> > +     ret = block_page_mkwrite(vma, vmf, nilfs_get_block, &err);
> >       if (ret) {
> >               nilfs_transaction_abort(inode->i_sb);
> >               goto out;
> > @@ -117,7 +121,7 @@ static vm_fault_t nilfs_page_mkwrite(struct vm_fault *vmf)
> >       wait_for_stable_page(page);
> >   out:
> >       sb_end_pagefault(inode->i_sb);
> > -     return block_page_mkwrite_return(ret);
> > +     return ret;
> >  }
> >
> >  static const struct vm_operations_struct nilfs_file_vm_ops = {
> > diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> > index 96225a7..e212b13 100644
> > --- a/include/linux/buffer_head.h
> > +++ b/include/linux/buffer_head.h
> > @@ -14,6 +14,7 @@
> >  #include <linux/pagemap.h>
> >  #include <linux/wait.h>
> >  #include <linux/atomic.h>
> > +#include <linux/mm_types.h>
> >
> >  #ifdef CONFIG_BLOCK
> >
> > @@ -239,10 +240,10 @@ int cont_write_begin(struct file *, struct address_space *, loff_t,
> >                       get_block_t *, loff_t *);
> >  int generic_cont_expand_simple(struct inode *inode, loff_t size);
> >  int block_commit_write(struct page *page, unsigned from, unsigned to);
> > -int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> > -                             get_block_t get_block);
> > +vm_fault_t block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> > +                             get_block_t get_block, int *err);
> >  /* Convert errno to return value from ->page_mkwrite() call */
> > -static inline int block_page_mkwrite_return(int err)
> > +static inline vm_fault_t block_page_mkwrite_return(int err)
> >  {
> >       if (err == 0)
> >               return VM_FAULT_LOCKED;
> > --
> > 1.9.1
> >
