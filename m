From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/19] libext2fs: check EA block headers when reading in
 the block
Date: Sat, 2 Aug 2014 22:33:08 -0400
Message-ID: <20140803023308.GE24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181214.12496.71494.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41925 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbaHCCdL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 22:33:11 -0400
Content-Disposition: inline
In-Reply-To: <20140801181214.12496.71494.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:12:14AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When reading an EA block in from disk, do a quick sanity check of the
> block header, and return an error if we think we have garbage.  Teach
> e2fsck to ignore the new error code in favor of doing its own
> checking, and remove the strict_csums bits while we're at it.
> 
> (Also document some assumptions in the new ext_attr code.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
