From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v3] ext4: implementation of a new ioctl called
 EXT4_IOC_SWAP_BOOT
Date: Sun, 7 Apr 2013 15:48:55 -0400
Message-ID: <20130407194855.GA5292@thunk.org>
References: <51023FEA.7000802@reinform.de>
 <20130126184927.GB20005@thunk.org>
 <op.wt48ybxow201t7@cnd0370px4.ent.rt.verigy.net>
 <20130407024701.GC7816@thunk.org>
 <45E0D5C6-50E8-4F2E-83DC-3E24A31D7573@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Dr. Tilmann Bubeck" <t.bubeck@reinform.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60066 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933168Ab3DGTtA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Apr 2013 15:49:00 -0400
Content-Disposition: inline
In-Reply-To: <45E0D5C6-50E8-4F2E-83DC-3E24A31D7573@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 07, 2013 at 11:09:58AM -0600, Andreas Dilger wrote:
> > +    filemap_flush(inode_bl->i_mapping);
> 
> Technically, it shouldn't be possible to have dirty pages on the
> bootloader inode, since any inode swapped there will itself have
> been flushed, and should not be directly accessible after that
> point. That said, I guess this ioctl() won't be called too often so
> the empty flush is mostly harmless.

Yes, technically there should be no mappings for the inode boot
loader.  (Well, unless someone had one of the unofficial open-by-inode
number patches).

> > +    if (inode_bl->i_nlink == 0) {
> > +        /* this inode has never been used as a BOOT_LOADER */
> > +        set_nlink(inode_bl, 1);
> > +        i_uid_write(inode_bl, 0);
> > +        i_gid_write(inode_bl, 0);
> > +        inode_bl->i_flags = 0;
> > +        ei_bl->i_flags = 0;
> > +        inode_bl->i_version = 1;
> > +        i_size_write(inode_bl, 0);
> > +        inode_bl->i_mode = S_IFREG;
> > +        if (EXT4_HAS_INCOMPAT_FEATURE(sb,
> > +                          EXT4_FEATURE_INCOMPAT_EXTENTS)) {
> > +            ext4_set_inode_flag(inode_bl, EXT4_INODE_EXTENTS);
> > +            ext4_ext_tree_init(handle, inode_bl);
> > +        } else
> > +            memset(ei_bl->i_data, 0, sizeof(ei_bl->i_data));
> 
> I don't understand this. Wouldn't this clobber the block pointers if 
> an existing boot inode and cause them to leak?  This seems broken to me. 

If i_nlink is zero, then there is no existing boot loader inode.  In
theory the rest of the inode is zero, but this is to make sure the
inode is initialized to something sane before we swap it into the
user-visible inode.

I'll fix up the rest of the minor errors and typos which you pointed
out, thanks!

						- Ted
