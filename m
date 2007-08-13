From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] [188/2many] MAINTAINERS - EXT4 FILE SYSTEM
Date: Mon, 13 Aug 2007 11:19:18 -0400
Message-ID: <20070813151917.GA28130@thunk.org>
References: <46bff9cc.cxIrFM29roaPmcfV%joe@perches.com> <20070813090128.GJ6689@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: joe@perches.com, torvalds@linux-foundation.org, sct@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, Eric Sandeen <esandeen@redhat.com>,
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48753 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S947206AbXHMPTX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2007 11:19:23 -0400
Content-Disposition: inline
In-Reply-To: <20070813090128.GJ6689@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 13, 2007 at 03:01:28AM -0600, Andreas Dilger wrote:
> >  EXT4 FILE SYSTEM
> > -P:	Stephen Tweedie, Andrew Morton
> > -M:	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
> > +P:	Stephen Tweedie
> > +M:	sct@redhat.com
> > +P:	Andrew Morton
> > +M:	akpm@linux-foundation.org
> > +P:	Andreas Dilger
> > +M:	adilger@clusterfs.com
> >  L:	linux-ext4@vger.kernel.org
> >  S:	Maintained
> > +F:	fs/ext4/
> > +F:	include/linux/ext4*
> 
> To be honest, Stephen and Andrew haven't been directly involved in
> the ext4 development.  It probably makes more sense to have e.g.
> Eric Sandeen, Ted Ts'o, and MingMing Cao in their place.

Yep, agreed.

					- Ted
