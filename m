From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 not currently doing (much) multi-block allocation?
Date: Sun, 15 Feb 2009 16:12:03 -0500
Message-ID: <20090215211203.GF10706@mini-me.lan>
References: <20090215053206.GA4803@mini-me.lan> <20090215110528.GE22585@skywalker> <20090215133618.GE10706@mini-me.lan> <20090215173629.GF22585@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55491 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbZBOVWr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Feb 2009 16:22:47 -0500
Content-Disposition: inline
In-Reply-To: <20090215173629.GF22585@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 15, 2009 at 11:06:29PM +0530, Aneesh Kumar K.V wrote:
> 
> That bh>b_size indicate multiple blocks. 
> 
> we do the below in mpage_add_bh_to_extent
> 
> 2024         if (logical == next && (bh->b_state & BH_FLAGS) == lbh->b_state) {
> 2025                 lbh->b_size += b_size;
> 2026                 return;
> 2027         }
> 

Urgh, right.  mpd->lbh isn't a real struct buffer_head at all; the
only fields we use out of it is b_size, b_state, and b_blocknr.  I
really dislike this coding style; it's hard to tell what is a real
buffer_head, and what is a fake buffer_head.  It also wastes about 200
bytes of kernel stack space.

There's a similar problem with bh_result; in which functions is it a
real buffer head (and must be a real buffer head), and in which
functions is it a fake buffer head, and which functions is it
sometimes a real buffer_head, and when it is a fake buffer_head?  This
is one of those things which makes for hard-to-maintain code.

							- Ted
