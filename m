From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/18] e2fsck: toggle checksum verification error
 reporting appropriately
Date: Mon, 28 Jul 2014 07:41:08 -0400
Message-ID: <20140728114108.GL6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003453.28334.47494.stgit@birch.djwong.org>
 <20140727233721.GA6725@thunk.org>
 <20140728073826.GB404@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60353 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbaG1LlO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2014 07:41:14 -0400
Content-Disposition: inline
In-Reply-To: <20140728073826.GB404@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 28, 2014 at 12:38:26AM -0700, Darrick J. Wong wrote:
> 
> We could make e2fsck verify the checksums itself, though we'd have to provide a
> way for either (a) libext2fs to provide the raw buffer data to e2fsck or (b)
> e2fsck to find the block number in question and (re)read the raw buffer, since
> the checksums are computed against the on-disk structures.

Hmm.  Another possibility is we could change the functions so that if
there is a checksum error, we return the error code, but we also
return the contents of the inode, directory entry, etc. to the caller.

       	   	       	   	  	    	   - Ted
