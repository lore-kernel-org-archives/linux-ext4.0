From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/4] Ext4: handle SEEK_HOLE/SEEK_DATA generically
Date: Tue, 28 Jun 2011 10:29:12 -0600
Message-ID: <40B8FEA5-D240-45CE-A903-946922CF449C@dilger.ca>
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <1309275199-10801-3-git-send-email-josef@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:15762 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759405Ab1F1Q3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jun 2011 12:29:15 -0400
In-Reply-To: <1309275199-10801-3-git-send-email-josef@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-28, at 9:33 AM, Josef Bacik wrote:
> Since Ext4 has its own lseek we need to make sure it handles
> SEEK_HOLE/SEEK_DATA.  For now just do the same thing that is done in the generic
> case, somebody else can come along and make it do fancy things later.  Thanks,

Josef,
are you planning to add an ext4-based version of this in the future?
Another possibility is to have a generic SEEK_{DATA,HOLE} -> FIEMAP
converter, since there are several filesystems that already support
FIEMAP (ext3, ext4, etc).

> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> fs/ext4/file.c |   21 +++++++++++++++++++++
> 1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 2c09723..ce766f9 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -236,6 +236,27 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int origin)
> 		}
> 		offset += file->f_pos;
> 		break;
> +	case SEEK_DATA:
> +		/*
> +		 * In the generic case the entire file is data, so as long as
> +		 * offset isn't at the end of the file then the offset is data.
> +		 */
> +		if (offset >= inode->i_size) {
> +			mutex_unlock(&inode->i_mutex);
> +			return -ENXIO;
> +		}
> +		break;
> +	case SEEK_HOLE:
> +		/*
> +		 * There is a virtual hole at the end of the file, so as long as
> +		 * offset isn't i_size or larger, return i_size.
> +		 */
> +		if (offset >= inode->i_size) {
> +			mutex_unlock(&inode->i_mutex);
> +			return -ENXIO;
> +		}
> +		offset = inode->i_size;
> +		break;
> 	}
> 
> 	if (offset < 0 || offset > maxbytes) {
> -- 
> 1.7.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





