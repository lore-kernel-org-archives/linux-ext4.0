From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] EXT4:  Use is_power_of_2() routine for clarity.
Date: Fri, 24 Apr 2009 13:34:50 -0400
Message-ID: <20090424173450.GJ7949@mit.edu>
References: <alpine.LFD.2.00.0904240905050.12966@localhost.localdomain> <49F1D4C3.5040804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
	linux-ext4@vger.kernel.org, Andrew Morton <akpm@osdl.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59903 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbZDXRfD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 13:35:03 -0400
Content-Disposition: inline
In-Reply-To: <49F1D4C3.5040804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 24, 2009 at 10:03:31AM -0500, Eric Sandeen wrote:
> > @@ -2092,7 +2092,7 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
> >  		return -EINVAL;
> > 
> >  	/* inode_readahead_blks must be a power of 2 */
> > -	if (t & (t-1))
> > +	if (!is_power_of_2(t))
> >  		return -EINVAL;

Might as well remove the comment; it's not needed if we're going to be
using is_power_of_2().

						- Ted
