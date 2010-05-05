From: tytso@mit.edu
Subject: Re: [PATCH, RFC 2/2] ext4: Convert callers of ext4_get_blocks() to
 use ext4_map_blocks()
Date: Wed, 5 May 2010 14:38:41 -0400
Message-ID: <20100505183841.GA18762@thunk.org>
References: <1272927081-12694-1-git-send-email-tytso@mit.edu>
 <1272927081-12694-2-git-send-email-tytso@mit.edu>
 <878w80htis.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35710 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab0EESiq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 May 2010 14:38:46 -0400
Content-Disposition: inline
In-Reply-To: <878w80htis.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 04, 2010 at 03:34:59PM +0530, Aneesh Kumar K. V wrote:
> > +	ret = ext4_map_blocks(NULL, inode, &map, 0);
> > +	if (ret < 0)
> > +		return ret;
> > +	if (ret == 0) {
> > +		if (!buffer_delay(bh)) {
> 
> bh flags are not set here. This check should be based on map.m_flags.

Actually, I looked more closely at this again today.
ext4_get_blocks() never messed with BH_DELAY, so this flag would only
be set or not set if it was originally set in the buffer_head before
it had been passed into ext4_get_blocks().

BTW, this is one of the reasons why I really hated the old system.  It
was never clear which flags were set by whom, and whether the flags
that had been in the struct bh before it had been passed into
ext4_get_blocks() was random stack garbage, or whether it had meaning,
etc.

I'm still not sure we have it all right, but it's clearly better to
use !buffer_delay(bh), since the buffer_delay flag is one that had
been never touched by ext4_get_blocks().

					- Ted
