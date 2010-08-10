From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: [Q] ext
Date: Tue, 10 Aug 2010 02:35:57 -0400
Message-ID: <ADCE32D6-3919-45CA-BA50-1BE86583F74D@oracle.com>
References: <20100810232321.0eb72247.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Ted Ts'o" <tytso@mit.edu>,
	linux-ext4 development <linux-ext4@vger.kernel.org>
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:26591 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab0HJGhd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Aug 2010 02:37:33 -0400
In-Reply-To: <20100810232321.0eb72247.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 2010-08-10, at 10:23, Toshiyuki Okajima wrote:
> Table. the max file size which we can write or seek
>       at each filesystem feature tuning and file flag setting
> +===============================+===============================+
> |                               |                               |
> |     !EXT4_EXTENTS_FL          |        EXT4_EXTETNS_FL        |
> |                               |                               |
> +-------------------------------+-------------------------------+
> |   write:      2194719883264   | write:       --------------   |
> |   seek:       2199023251456   | seek:        --------------   |
> +-------------------------------+-------------------------------+
> |   write:      4402345721856   | write:       17592186044415   |
> |   seek:      17592186044415   | seek:        17592186044415   |
> +-------------------------------+-------------------------------+

Interesting.  The 2TB vs. 4TB difference for block-mapped files is due to the removal of the 2^32 sectors limit imposed by i_blocks, and is not strictly related to extents.

> +loff_t ext4_llseek(struct file *file, loff_t offset, int origin)
> +{
> +	struct inode *inode = file->f_mapping->host;
> +	loff_t maxbytes;
> +
> +	mutex_lock(&inode->i_mutex);
> +	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> +		maxbytes = EXT4_SB(inode->i_sb)->s_bitmap_maxbytes;
> +	else
> +		maxbytes = inode->i_sb->s_maxbytes;

This part doesn't really have to be under i_mutex.  Otherwise, the patch looks reasonable.

> +	switch (origin) {
> +	case SEEK_END:
> +		offset += inode->i_size;
> +		break;
> +	case SEEK_CUR:
> +		if (offset == 0) {
> +			mutex_unlock(&inode->i_mutex);
> +			return file->f_pos;
> +		}
> +		offset += file->f_pos;
> +		break;
> +       	}
> +
> +	if (offset < 0 || offset > maxbytes) {
> +		mutex_unlock(&inode->i_mutex);
> +		return -EINVAL;
> +	}
> +
> +	if (offset != file->f_pos) {
> +		file->f_pos = offset;
> +		file->f_version = 0;
> +	}
> +	mutex_unlock(&inode->i_mutex);
> + 
> +	return offset;
> +}

It's too bad that we have to duplicate the whole generic_file_llseek() code here, but I don't think there is a better solution.  However, it is worthwhile to add a comment to this function like:

/* copied from generic_file_llseek() to handle both block-mapped and
 * extent-mapped maxbytes values.  Should otherwise be identical. */

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

