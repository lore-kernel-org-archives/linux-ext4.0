From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v2 2/5] ext4: call dax_get_unmapped_area() for DAX pmd
 mappings
Date: Tue, 12 Apr 2016 23:01:56 -0400
Message-ID: <20160413030156.GN2781@linux.intel.com>
References: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com,
	linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 12, 2016 at 02:39:29PM -0600, Toshi Kani wrote:
> To support DAX pmd mappings with unmodified applications,
> filesystems need to align an mmap address by the pmd size.

> @@ -708,6 +708,9 @@ const struct file_operations ext4_file_operations = {
>  	.open		= ext4_file_open,
>  	.release	= ext4_release_file,
>  	.fsync		= ext4_sync_file,
> +#ifdef CONFIG_FS_DAX
> +	.get_unmapped_area = dax_get_unmapped_area,
> +#endif
>  	.splice_read	= generic_file_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= ext4_fallocate,

Could you do something like:

 #ifdef CONFIG_FS_DAX
 struct page *read_dax_sector(struct block_device *bdev, sector_t n);
+unsigned long dax_get_unmapped_area(struct file *filp, unsigned long addr,
+               unsigned long len, unsigned long pgoff, unsigned long flags);
 #else
 static inline struct page *read_dax_sector(struct block_device *bdev,
                 sector_t n)
 {
         return ERR_PTR(-ENXIO);
 }
+#define dax_get_unmapped_area	NULL
 #endif

in patch 1/5.  Then there's no need for the ifdefs in each filesystem.
