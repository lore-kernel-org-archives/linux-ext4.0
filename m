From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/25] tests: test writing and recovering checksum-free
 32/64bit journals
Date: Thu, 11 Sep 2014 16:59:03 -0400
Message-ID: <20140911205903.GF8366@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231301.25904.5733.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51975 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbaIKU7F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 16:59:05 -0400
Content-Disposition: inline
In-Reply-To: <20140908231301.25904.5733.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:13:01PM -0700, Darrick J. Wong wrote:
> Simple tests for the journal transaction creation code.   We test
> writing (bad) block bitmaps out through the journal and replaying them
> via fsck, with a few twists:
> 
> (a) All bitmaps are committed (fs errors reported)
> (b) All the bitmap blocks are revoked (no errors)
> (c) The transaction is never committed (no errors)
> (d) Same as (a), but debugfs gets to do the replay.
> 
> We also test:
> 
> (a) writing and replaying transactions with multiple
>     descriptor blocks
> (b) same, but with multiple revoke blocks.
> (c) adding the 64bit flag to a journal
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
