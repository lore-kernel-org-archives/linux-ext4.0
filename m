From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs coverity patch <cid-11.diff>
Date: Wed, 21 Mar 2007 20:52:42 -0400
Message-ID: <20070322005242.GA23643@thunk.org>
References: <200702100211.l1A2B9wF007009@igsi.llnl.gov> <20070321185445.GA17405@thunk.org> <1174504455.13386.30.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Brian D. Behlendorf" <behlendorf1@llnl.gov>,
	linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	wartens2@llnl.gov
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42776 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965104AbXCVAwv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2007 20:52:51 -0400
Content-Disposition: inline
In-Reply-To: <1174504455.13386.30.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 21, 2007 at 02:14:15PM -0500, Dave Kleikamp wrote:
> > > Coverity ID: 11: Overrun Static
> > > 
> > > -	thislen = ((dirent->name_len & 0xFF) < EXT2_NAME_LEN) ?
> > > +	thislen = ((dirent->name_len & 0xFF) <= EXT2_NAME_LEN) ?
> > >  		(dirent->name_len & 0xFF) : EXT2_NAME_LEN;
> > 
> > This change is largely meaningless/unnecessary, since if
> > *dirent->name_len & 0xFF) is equal to EXT2_NAME_LEN it doesn't matter
> > which path is chosen; was there a reason for the change.
> 
> #define EXT2_NAME_LEN 255
> 
> How about this?
> 
> 	thislen = dirent->name_len & 0xFF;

It's unlikely that EXT2_NAME_LEN will ever change, so yes, that's
probably a good idea.  I've alrady committed the patch, though so
we'll do it later.

						- Ted
