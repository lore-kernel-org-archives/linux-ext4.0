From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Mon, 29 Oct 2007 16:29:07 -0600
Message-ID: <20071029222907.GF3042@webber.adilger.int>
References: <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1FA8E92B-954D-4624-A089-80D4AA7399FD@cam.ac.uk> <20070502000654.GK77450368@melbourne.sgi.com> <8464EA47-03AC-4162-A2D0-683517568640@cam.ac.uk> <20071029194507.GA8578@webber.adilger.int> <20071029205744.GB28607@ca-server1.us.oracle.com> <20071029221302.GD3042@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Mark Fasheh <mark.fasheh@oracle.com>,
	linux-fsdevel@vger.kernel.org, David Chinner <dgc@sgi.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org,
	Anton Altaparmakov <a
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:52641 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbXJ2W3J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Oct 2007 18:29:09 -0400
Content-Disposition: inline
In-Reply-To: <20071029221302.GD3042@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 29, 2007  16:13 -0600, Andreas Dilger wrote:
> On Oct 29, 2007  13:57 -0700, Mark Fasheh wrote:
> > I'm a little bit confused by fe_offset. Is it a physical offset, or a
> > logical offset? The reason I ask is that your description above says "FIEMAP
> > ioctl will return the logical to physical mapping for the extent that
> > contains the specified logical byte address." Which seems to imply physical,
> > but your math to get to the next logical start in a very fragmented file,
> > implies that fe_offset is a logical offset:
> > 
> >        fm_start = fm_extents[fm_extent_count - 1].fe_offset +
> >                          fm_extents[fm_extent_count - 1].fe_length + 1; 
> 
> Note the distinction between "fe_offset" (which is a physical offset for
> a single extent) and "fm_offset" (which is a logical offset for that file).

Actually, that is completely bunk.  What it should say is something like:
"filefrag can easily call the FIEMAP ioctls repeatedly using the returned
fm_start and fm_length as the start offset for the next ioctl:

        fiemap.fm_start = fiemap.fm_start + fiemap.fm_length + 1;

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
