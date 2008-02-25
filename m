From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Mon, 25 Feb 2008 10:13:39 -0500
Message-ID: <20080225151339.GB8408@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <47BC75A1.10605@redhat.com> <20080221140546.GF14614@mit.edu> <47BDA978.7060403@redhat.com> <20080222231434.GG3029@webber.adilger.int> <20080223001539.GD20118@mit.edu> <20080225042050.GH3534@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:39960 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750896AbYBYPNr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Feb 2008 10:13:47 -0500
Content-Disposition: inline
In-Reply-To: <20080225042050.GH3534@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 24, 2008 at 09:20:50PM -0700, Andreas Dilger wrote:
> On Feb 22, 2008  19:15 -0500, Theodore Ts'o wrote:
> > So before the recent patch were we actually creating long symlinks in
> > extents format?  Or were we just setting the flag but still treating
> > them as a block number?  If it was the latter, I guess we can put in
> > code into e2fsck to detect that case, and convert it back to a
> > singleton block number.  
> 
> Eric informed me that the long symlinks were actually stored in extent
> mapped blocks.  That is not harmful, because it can only be a single
> block and it will always fit into the inode.  The other thing to note
> is that extent mapping is REQUIRED for > 32-bit blocknumbers, so we
> may as well fix e2fsprogs to allow these symlinks to be handled normally.

Well, at least some kernel versions (as of sometime just before
2.6.25, iirc) were storing the long symlink as a single block in
i_block[0], despite EXTENTS_FL being set.  Valerie noticed this, and I
confirmed it, as it caused the mainline e2fsck extents support to core
dump.  Basically, what this means is that e2fsprogs can't trust
EXTENTS_FL for long symlinks.

But you do raise a good point that we need to support using the
extents format in order to support blocks > 2**32, so we can't just
arbitrary convert all symlinks to the old-style direct block maps.

	  	      	       	       		- Ted
