From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/3] fs: Fix remaining filesystems to wait for stable
 page writeback
Date: Thu, 1 Nov 2012 13:36:41 +0100
Message-ID: <20121101123641.GA23132@quack.suse.cz>
References: <20121101075805.16153.64714.stgit@blackbox.djwong.org>
 <20121101075829.16153.92036.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org,
	ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mfasheh-IBi9RG/b67k@public.gmane.org, dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org, rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org,
	martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
	linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121101075829.16153.92036.stgit-yuuUpGxbzT9UbpRmUfBrXUB+6BGkLq7r@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu 01-11-12 00:58:29, Darrick J. Wong wrote:
> Fix up the filesystems that provide their own ->page_mkwrite handlers to
> provide stable page writes if necessary.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/9p/vfs_file.c |    1 +
>  fs/afs/write.c   |    4 ++--
>  fs/ceph/addr.c   |    1 +
>  fs/cifs/file.c   |    1 +
>  fs/ocfs2/mmap.c  |    1 +
>  fs/ubifs/file.c  |    4 ++--
>  6 files changed, 8 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
> index c2483e9..aa253f0 100644
> --- a/fs/9p/vfs_file.c
> +++ b/fs/9p/vfs_file.c
> @@ -620,6 +620,7 @@ v9fs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	lock_page(page);
>  	if (page->mapping != inode->i_mapping)
>  		goto out_unlock;
> +	wait_on_stable_page_write(page);
>  
>  	return VM_FAULT_LOCKED;
>  out_unlock:
> diff --git a/fs/afs/write.c b/fs/afs/write.c
> index 9aa52d9..39eb2a4 100644
> --- a/fs/afs/write.c
> +++ b/fs/afs/write.c
> @@ -758,7 +758,7 @@ int afs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
>  #ifdef CONFIG_AFS_FSCACHE
>  	fscache_wait_on_page_write(vnode->cache, page);
>  #endif
> -
> +	wait_on_stable_page_write(page);
>  	_leave(" = 0");
> -	return 0;
> +	return VM_FAULT_LOCKED;
>  }
  Oh, I missed these two since I've got confused by
fscache_wait_on_page_write().

> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 47a87dd..a0027b1 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -124,6 +124,7 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
>  				     fsdata);
>  	BUG_ON(ret != len);
>  	ret = VM_FAULT_LOCKED;
> +	wait_on_stable_page_write(page);
>  out:
>  	return ret;
>  }
  Actually, this is not so easy. ocfs2 doesn't use
grab_cache_page_write_begin() so you have to modify write_begin() path as
well. And then you don't have to modify __ocfs2_page_mkwrite() because it
uses ocfs2_write_begin(). Preferably teach it to use
grab_cache_page_write_begin()...

  And I think you are missing ncpfs. Because ncp_file_mmap does not set
.mkwrite - it should use filemap_page_mkwrite() I think.

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
