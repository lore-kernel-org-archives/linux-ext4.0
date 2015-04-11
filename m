From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/22] ext4 crypto: implement the ext4 encryption write
 path
Date: Sat, 11 Apr 2015 09:17:07 -0400
Message-ID: <20150411131707.GF6540@thunk.org>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
 <1428012659-12709-13-git-send-email-tytso@mit.edu>
 <6F10E7A2-7D43-4C16-BEED-4568169AA12D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com,
	Ildar Muslukhov <ildarm@google.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34141 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbbDKNRK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Apr 2015 09:17:10 -0400
Content-Disposition: inline
In-Reply-To: <6F10E7A2-7D43-4C16-BEED-4568169AA12D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 09, 2015 at 03:44:35PM -0600, Andreas Dilger wrote:
> > 
> > +	/*
> > +	 * TODO: We don't yet support fallocate with encrypted files.
> > +	 */
> > +	if (ext4_encrypted_inode(inode))
> > +		return -EOPNOTSUPP;
> 
> Any plans for this?  Would reading from encrypted files with unwritten
> extents just generate garbage from urandom if the key wasn't available,
> or would it still return zero?

This is on my todo list to fix.  It actually mostly works today,
except for when we write into the middle of an unwritten extent, under
some circumstances the extent splitting code will simply write zeros
to some of the unwritten pages to avoid needing to split a leaf node.
So what we need to do is implement a function which encrypts the zero
page and writes that out instead of just calling sb_issue_zeroout().

     	 	     	 	    - Ted
