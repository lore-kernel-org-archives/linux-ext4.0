From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Mon, 25 Feb 2008 15:23:00 -0500
Message-ID: <20080225202300.GC8386@mit.edu>
References: <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <47BC75A1.10605@redhat.com> <20080221140546.GF14614@mit.edu> <47BDA978.7060403@redhat.com> <20080222231434.GG3029@webber.adilger.int> <20080223001539.GD20118@mit.edu> <20080225042050.GH3534@webber.adilger.int> <20080225151339.GB8408@mit.edu> <47C2FBB2.30404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60547 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756862AbYBYUYG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2008 15:24:06 -0500
Content-Disposition: inline
In-Reply-To: <47C2FBB2.30404@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 25, 2008 at 11:32:34AM -0600, Eric Sandeen wrote:
> Are you sure?  This was her patch comment, from
> [PATCH] ext4: Don't set EXTENTS_FL flag for fast symlinks:

You're right, I confused myself.

> > But you do raise a good point that we need to support using the
> > extents format in order to support blocks > 2**32, so we can't just
> > arbitrary convert all symlinks to the old-style direct block maps.
> 
> ... so I think we really *should* be unconditionally storing *long*
> symlinks in extent format, on ext4... right?

Yes, I think so.  Being liberal in what you receive is probably a good
idea, but we should only store new symlinks in one standard format,
and the extents format makes sense since it will allow us to support
48-bit block numbers.

            	     	    	       	   - Ted
