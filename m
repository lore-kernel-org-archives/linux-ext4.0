From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Date: Thu, 27 Aug 2009 13:35:40 -0400
Message-ID: <20090827173540.GA19115@infradead.org>
References: <1250875447-15622-1-git-send-email-jack@suse.cz> <1250875447-15622-8-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de,
	linux-fsdevel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
	ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
	Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com,
	Anton Altaparmakov <aia21@cantab.net>,
	linux-ntfs-dev@lists.sourceforge.net,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZH0Rfm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Aug 2009 13:35:42 -0400
Content-Disposition: inline
In-Reply-To: <1250875447-15622-8-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> +int generic_write_sync(struct file *file, loff_t pos, loff_t count)
> +{
> +	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
> +		return 0;
> +	return generic_sync_file(file, file->f_path.dentry, pos,
> +				 pos + count - 1,
> +				 SYNC_SUBMIT_DATA | SYNC_WAIT_DATA);
> +}
> +EXPORT_SYMBOL(generic_write_sync);

>  
> +/* Flags for generic_sync_file */
> +#define SYNC_INODE		1
> +#define SYNC_SUBMIT_DATA	2
> +#define SYNC_WAIT_DATA		4

When I think about this more I really hate the latter two flags.
There's really no reason to just do only either the submit or wait.
I'd say kill the flags for now and just implement generic_write_sync
as:

int generic_write_sync(struct file *file, loff_t pos, loff_t count)
{
	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
		return 0;
	return vfs_fsync_range(file, file->f_path.dentry, pos,
			       pos + count - 1, 1);
}

and we can look into replacing the datasync flag with something more
meaningfull later through the whole fsync stack.
