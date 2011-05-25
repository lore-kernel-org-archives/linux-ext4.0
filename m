From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 1/3] fs: add SEEK_HOLE and SEEK_DATA flags V4
Date: Wed, 25 May 2011 13:45:56 -0600
Message-ID: <0E7B812A-4057-4EB8-93F5-79ED9FCE2CCD@dilger.ca>
References: <1306186991-1905-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	sunil.mushran@oracle.com, viro@ZenIV.linux.org.uk
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1306186991-1905-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 23, 2011, at 15:43, Josef Bacik wrote:
> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.  Turns out
> using fiemap in things like cp cause more problems than it solves, so lets try
> and give userspace an interface that doesn't suck.  We need to match solaris
> here, and the definitions are
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 5520f8a..9c3b453 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -64,6 +64,23 @@ generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
> 			return file->f_pos;
> 		offset += file->f_pos;
> 		break;
> +	case SEEK_DATA:
> +		/*
> +		 * In the generic case the entire file is data, so as long as
> +		 * offset isn't at the end of the file then the offset is data.
> +		 */
> +		if (offset >= inode->i_size)
> +			return -ENXIO;
> +		break;
> +	case SEEK_HOLE:
> +		/*
> +		 * There is a virtual hole at the end of the file, so as long as
> +		 * offset isn't i_size or larger, return i_size.
> +		 */
> +		if (offset >= inode->i_size)
> +			return -ENXIO;
> +		offset = inode->i_size;
> +		break;
> 	}

What about all of the existing filesystems that currently just ignore
values of "origin" that they don't understand?  Looking through those
it appears that most of them will return "offset" for unknown values
of "origin", which I guess is OK for SEEK_DATA, but is confusing for
SEEK_HOLE.  Some filesystems will return -EINVAL for values of origin
that are unknown.

Most of the filesystem-specific ->llseek() methods don't do any error
checking on "origin" because this is handled at the sys_llseek() level,
and hasn't changed in many years.

I assume this patch is also dependent upon the "remove default_llseek()"
patch, so that the implementation of SEEK_DATA and SEEK_HOLE can be done
in only generic_file_llseek()?

Finally, while looking through the various ->llseek() methods I notice
that many filesystems return "i_size" for SEEK_END, which clearly does
not make sense for filesystems like ext3/ext4 htree, btrfs, etc that
use hash keys instead of byte offsets for doing directory traversal.
The comment at generic_file_llseek() is that it is intended for use by
regular files.

Should the ext4_llseek() code be changed to return 0x7ffffffff for the
SEEK_END value?  That makes more sense compared to values returned for
SEEK_CUR so that an application can compare the current "offset" with
the final value for a progress bar.

Another interesting use is for N threads to process a large directory
in parallel by using max_off = llseek(dirfd, 0, SEEK_END) and then
each thread calls llseek(dirfd, thread_nr * max_off / N, SEEK_SET)
to process 1/N of the directory.


Cheers, Andreas






Cheers, Andreas
