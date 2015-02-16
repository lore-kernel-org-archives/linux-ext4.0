From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 19/54] e2fsck: salvage under-sized dirents by removing
 them
Date: Mon, 16 Feb 2015 10:40:42 -0500
Message-ID: <20150216154042.GD16560@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073737.13308.74557.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48758 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbbBPPkq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Feb 2015 10:40:46 -0500
Content-Disposition: inline
In-Reply-To: <20150127073737.13308.74557.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:37:37PM -0800, Darrick J. Wong wrote:
> If the directory processing code ends up pointing to a directory entry
> that's so close to the end of the block that there's not even space
> for a rec_len/name_len, just substitute dummy values that will force
> e2fsck to extend the previous entry to cover the remaining space.  We
> can't use the helper methods to extract rec_len because that's reading
> off the end of the buffer.
> 
> This isn't an issue with non-inline directories because the directory
> check buffer is zero-extended so that fsck won't blow up.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
