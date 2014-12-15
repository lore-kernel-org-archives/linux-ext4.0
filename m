From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 31/47] libext2fs/e2fsck: provide routines to read-ahead
 metadata
Date: Mon, 15 Dec 2014 12:36:28 -0500
Message-ID: <20141215173628.GB21646@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215407.883.32839.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57208 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaLORg3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2014 12:36:29 -0500
Content-Disposition: inline
In-Reply-To: <20141107215407.883.32839.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:54:07PM -0800, Darrick J. Wong wrote:
> 
> v2: Add an API to create a dblist with a given number of list elements
> pre-allocated.  This enables us to save ~2ms per call to
> e2fsck_readahead() (assuming a 2MB RA buffer) by not having to
> repeatedly call ext2_resize_mem as we add blocks to the list.

I don't see the API to create a dblist with a specified number of list
elements?  It should be pretty trivial, given make_dblist() but I
don't see it in this patch?

						- Ted
