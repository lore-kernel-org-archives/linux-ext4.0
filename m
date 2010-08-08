From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
Date: Sun, 8 Aug 2010 12:40:45 -0400
Message-ID: <20100808164045.GA17549@shell>
References: <1281134124-17041-1-git-send-email-vaurora@redhat.com> <1281134124-17041-15-git-send-email-vaurora@redhat.com> <11B0076E-9611-459A-93D4-04DFA369FF52@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Jan Blunck <jblunck@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab0HHQlH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Aug 2010 12:41:07 -0400
Content-Disposition: inline
In-Reply-To: <11B0076E-9611-459A-93D4-04DFA369FF52@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 06, 2010 at 06:28:29PM -0600, Andreas Dilger wrote:
> On 2010-08-06, at 16:35, Valerie Aurora wrote:
> > XXX What to do for d_ino for fallthrus?  If we return the inode from
> > the the underlying file system, it comes from a different inode
> > "namespace" and that will produce spurious matches.  This argues for
> > implementation of fallthrus as symlinks because they have to allocate
> > an inode (and inode number) anyway, and we can later reuse it if we
> > copy the file up.
> > 
> > @@ -342,6 +344,24 @@ ext2_readdir (struct file * filp, void * dirent, +				/* XXX We don't know the inode number
> > +				 * of the directory entry in the
> > +				 * underlying file system.  Should
> > +				 * look it up, either on fallthru
> > +				 * creation at first readdir or now at
> > +				 * filldir time. */
> > +				over = filldir(dirent, de->name, de->name_len,
> > +					       (n<<PAGE_CACHE_SHIFT) | offset,
> > +					       123 /* Made up ino */, d_type);
> 
> I don't think it makes sense to use "123" for the inode number.  This is a valid inode number, and almost certainly one that will be in use in most filesystems.  One option for extN is to use EXT2_BAD_INO (1).

The next version (Subject: Union mounts - return d_ino from lower fs)
fixed this.  Take a look and tell me what you think?

-VAL
