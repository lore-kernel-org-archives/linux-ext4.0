From: Jan Kara <jack@suse.cz>
Subject: Re: + ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch added to
 -mm tree
Date: Mon, 19 Jan 2015 10:45:08 +0100
Message-ID: <20150119094507.GA5662@quack.suse.cz>
References: <54b4548f.X6zUbiROuSfruGuT%akpm@linux-foundation.org>
 <20150115103036.GE12739@quack.suse.cz>
 <100D68C7BA14664A8938383216E40DE04085342E@FMSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Dilger, Andreas" <andreas.dilger@intel.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"boaz@plexistor.com" <boaz@plexistor.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"hch@lst.de" <hch@lst.de>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
	"rdunlap@infradead.org" <rdunlap@infradead.org>,
	"ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbbASJpL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Jan 2015 04:45:11 -0500
Content-Disposition: inline
In-Reply-To: <100D68C7BA14664A8938383216E40DE04085342E@FMSMSX114.amr.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 16-01-15 21:09:03, Wilcox, Matthew R wrote:
> -----Original Message-----
> From: Jan Kara [mailto:jack@suse.cz] 
> Sent: Thursday, January 15, 2015 2:31 AM
> To: Wilcox, Matthew R
> Cc: akpm@linux-foundation.org; Dilger, Andreas; axboe@kernel.dk; boaz@plexistor.com; david@fromorbit.com; hch@lst.de; jack@suse.cz; kirill.shutemov@linux.intel.com; mathieu.desnoyers@efficios.com; rdunlap@infradead.org; ross.zwisler@linux.intel.com; tytso@mit.edu; mm-commits@vger.kernel.org; linux-ext4@vger.kernel.org
> Subject: Re: + ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch added to -mm tree
> 
> On Mon 12-01-15 15:11:11, Andrew Morton wrote:
> ...
> > diff -puN fs/ext2/ext2.h~ext2-get-rid-of-most-mentions-of-xip-in-ext2 fs/ext2/ext2.h
> > --- a/fs/ext2/ext2.h~ext2-get-rid-of-most-mentions-of-xip-in-ext2
> > +++ a/fs/ext2/ext2.h
> > @@ -380,14 +380,15 @@ struct ext2_inode {
> >  #define EXT2_MOUNT_NO_UID32		0x000200  /* Disable 32-bit UIDs */
> >  #define EXT2_MOUNT_XATTR_USER		0x004000  /* Extended user attributes */
> >  #define EXT2_MOUNT_POSIX_ACL		0x008000  /* POSIX Access Control Lists */
> > -#ifdef CONFIG_FS_DAX
> > -#define EXT2_MOUNT_XIP			0x010000  /* Execute in place */
> > -#else
> > -#define EXT2_MOUNT_XIP			0
> > -#endif
> > +#define EXT2_MOUNT_XIP			0x010000  /* Obsolete, use DAX */
> >  #define EXT2_MOUNT_USRQUOTA		0x020000  /* user quota */
> >  #define EXT2_MOUNT_GRPQUOTA		0x040000  /* group quota */
> >  #define EXT2_MOUNT_RESERVATION		0x080000  /* Preallocation */
> > +#ifdef CONFIG_FS_DAX
> > +#define EXT2_MOUNT_DAX			0x100000  /* Direct Access */
> > +#else
> > +#define EXT2_MOUNT_DAX			0
> > +#endif
>   Why do you define EXT2_MOUNT_DAX differently depending on CONFIG_FS_DAX?
>   That seems unnecessary...
> 
> That's copied from the original XIP code.  I think the intent is to make the XIP/DAX code disappear from the module, rather than being dead code cluttering up the object file.
  I see. OK.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
