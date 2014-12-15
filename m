From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 31/47] libext2fs/e2fsck: provide routines to read-ahead
 metadata
Date: Mon, 15 Dec 2014 11:19:41 -0800
Message-ID: <20141215191941.GE5368@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215407.883.32839.stgit@birch.djwong.org>
 <20141215173628.GB21646@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29340 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaLOTTr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Dec 2014 14:19:47 -0500
Content-Disposition: inline
In-Reply-To: <20141215173628.GB21646@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 15, 2014 at 12:36:28PM -0500, Theodore Ts'o wrote:
> On Fri, Nov 07, 2014 at 01:54:07PM -0800, Darrick J. Wong wrote:
> > 
> > v2: Add an API to create a dblist with a given number of list elements
> > pre-allocated.  This enables us to save ~2ms per call to
> > e2fsck_readahead() (assuming a 2MB RA buffer) by not having to
> > repeatedly call ext2_resize_mem as we add blocks to the list.
> 
> I don't see the API to create a dblist with a specified number of list
> elements?  It should be pretty trivial, given make_dblist() but I
> don't see it in this patch?

Ugh, part of the commit message came off.  There should be after that:

v3: Instead of creating dblists of arbitrary size, change the dblist
iterator to allow iterating a sub-range.  This eliminates a lot of
unnecessary list copying during e2fsck part2.

Sorry about that. :/

--D
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
