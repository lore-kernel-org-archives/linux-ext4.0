From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
Date: Fri, 6 Aug 2010 18:28:29 -0600
Message-ID: <11B0076E-9611-459A-93D4-04DFA369FF52@dilger.ca>
References: <1281134124-17041-1-git-send-email-vaurora@redhat.com> <1281134124-17041-15-git-send-email-vaurora@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Jan Blunck <jblunck@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:3873 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab0HGA2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Aug 2010 20:28:31 -0400
In-Reply-To: <1281134124-17041-15-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-06, at 16:35, Valerie Aurora wrote:
> XXX What to do for d_ino for fallthrus?  If we return the inode from
> the the underlying file system, it comes from a different inode
> "namespace" and that will produce spurious matches.  This argues for
> implementation of fallthrus as symlinks because they have to allocate
> an inode (and inode number) anyway, and we can later reuse it if we
> copy the file up.
> 
> @@ -342,6 +344,24 @@ ext2_readdir (struct file * filp, void * dirent, +				/* XXX We don't know the inode number
> +				 * of the directory entry in the
> +				 * underlying file system.  Should
> +				 * look it up, either on fallthru
> +				 * creation at first readdir or now at
> +				 * filldir time. */
> +				over = filldir(dirent, de->name, de->name_len,
> +					       (n<<PAGE_CACHE_SHIFT) | offset,
> +					       123 /* Made up ino */, d_type);

I don't think it makes sense to use "123" for the inode number.  This is a valid inode number, and almost certainly one that will be in use in most filesystems.  One option for extN is to use EXT2_BAD_INO (1).

Cheers, Andreas





