From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] fs: ext4: use new return type vm_fault_t
Date: Mon, 16 Jul 2018 10:19:37 +0530
Message-ID: <CAFqt6zaEou5CPYCqi=HezSK-UA7AnRECZNe373Nw+bDd1aF0zw@mail.gmail.com>
References: <20180707103029.GA13365@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        Matthew Wilcox <willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180707103029.GA13365@jordon-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jul 7, 2018 at 4:00 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
> Use new return type vm_fault_t for fault handler
> ext4_filemap_fault.
>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

Any comment on this patch ?
> ---
>  fs/ext4/ext4.h  | 2 +-
>  fs/ext4/inode.c | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 0b12785..aec0010 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2470,7 +2470,7 @@ int do_journal_get_write_access(handle_t *handle,
>  extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
>                              loff_t lstart, loff_t lend);
>  extern int ext4_page_mkwrite(struct vm_fault *vmf);
> -extern int ext4_filemap_fault(struct vm_fault *vmf);
> +extern vm_fault_t ext4_filemap_fault(struct vm_fault *vmf);
>  extern qsize_t *ext4_get_reserved_space(struct inode *inode);
>  extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
>  extern void ext4_da_update_reserve_space(struct inode *inode,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 2ea07ef..03ac322 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6205,14 +6205,14 @@ int ext4_page_mkwrite(struct vm_fault *vmf)
>         return ret;
>  }
>
> -int ext4_filemap_fault(struct vm_fault *vmf)
> +vm_fault_t ext4_filemap_fault(struct vm_fault *vmf)
>  {
>         struct inode *inode = file_inode(vmf->vma->vm_file);
> -       int err;
> +       vm_fault_t ret;
>
>         down_read(&EXT4_I(inode)->i_mmap_sem);
> -       err = filemap_fault(vmf);
> +       ret = filemap_fault(vmf);
>         up_read(&EXT4_I(inode)->i_mmap_sem);
>
> -       return err;
> +       return ret;
>  }
> --
> 1.9.1
>
