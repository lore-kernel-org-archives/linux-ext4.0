From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Wed, 2 May 2007 19:48:51 +1000
Message-ID: <20070502094851.GX77450368@melbourne.sgi.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <20070501223040.GL5722@schatzie.adilger.int> <03C89173-3AD1-421F-B7A0-64C999BD9DAB@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>,
	David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org
To: Anton Altaparmakov <aia21@cam.ac.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <03C89173-3AD1-421F-B7A0-64C999BD9DAB@cam.ac.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 02, 2007 at 09:23:38AM +0100, Anton Altaparmakov wrote:
> On a different issue, do you think it would be worth adding an option  
> flags like FIEMAP_DONT_RELOCATE or something similar that would be a  
> compulsory flag and if set the FS is not allowed to move the file  
> around/change the block allocation of the file.

We already have an inode flag in XFS to say this - the defrag
tool checks it and ignores the file if it is set.

> Or alternatively a flag like FIEMAP_MAKE_DIRECT or something to tell  
> the FS we want to access the actual raw blocks so the FS can make  
> sure the data is on block aligned boundaries and if the FS does not  
> support this (e.g. ZFS or a compressed or encrypted NTFS file) then  
> it can return -ENOTSUP.
>
> Perhaps this is totally the wrong interface and such a "prepare file  
> for direct access" API should be a different ioctl() or syscall or  
> whatever.  It just seems very simple and appropriate to combine it  
> here as people who use FIEMAP are at least sometimes going to be  
> wanting to access those blocks directly as well and it feels right to  
> be able to communicate this to the FS in the same call, kind of like  
> an "open intent" of "I want to use the data directly on disk"...

I think this is wrong interface for this. Sure, use it to get the
mappings (that's what it's for) but what you do with the mappings
after that is not part of FIEMAP....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
