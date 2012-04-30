From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] ext3: pass custom EOF to generic_file_llseek_size()
Date: Tue, 1 May 2012 00:10:16 +0200
Message-ID: <20120430221016.GE10105@quack.suse.cz>
References: <4F9AC770.8080004@redhat.com>
 <20120428183315.GA28349@parisc-linux.org>
 <4F9ED6E4.6050908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew@wil.cx>, Jan Kara <jack@suse.cz>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F9ED6E4.6050908@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 30-04-12 13:16:04, Eric Sandeen wrote:
> Use the new custom EOF argument to generic_file_llseek_size so
> that SEEK_END will go to the max hash value for htree dirs
> in ext3 rather than to i_size_read()
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
  Looks good. I suppose you want to merge all three patches at once so:
Acked-by: Jan Kara <jack@suse.cz>

							Honza
> ---
> 
> diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
> index 92490e9..c8fff93 100644
> --- a/fs/ext3/dir.c
> +++ b/fs/ext3/dir.c
> @@ -300,10 +300,11 @@ loff_t ext3_dir_llseek(struct file *file, loff_t offset, int origin)
>  {
>  	struct inode *inode = file->f_mapping->host;
>  	int dx_dir = is_dx_dir(inode);
> +	loff_t htree_max = ext3_get_htree_eof(file);
>  
>  	if (likely(dx_dir))
>  		return generic_file_llseek_size(file, offset, origin,
> -					        ext3_get_htree_eof(file));
> +					        htree_max, htree_max);
>  	else
>  		return generic_file_llseek(file, offset, origin);
>  }
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
