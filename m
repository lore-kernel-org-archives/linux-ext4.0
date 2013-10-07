From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/31] libext2fs: When writing a file that has a i_size >
 2GB, set the large_file feature flag and update the superblock.
Date: Mon, 7 Oct 2013 09:14:30 -0400
Message-ID: <20131007131430.GB4540@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012728.28415.89082.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43064 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab3JGNOd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Oct 2013 09:14:33 -0400
Content-Disposition: inline
In-Reply-To: <20131001012728.28415.89082.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:27:28PM -0700, Darrick J. Wong wrote:
> If someone tries to write a file that is larger than 2GB, we need to set the
> large_file feature flag to affirm that i_size_hi can hold meaningful contents.
> (I don't see anything checking large_file except e2fsck...)

The large_file feature is there to protect ancient (2.2?) kernels that
didn't understand large files.  It's largely not needed in modern
kernels, which all understand it.

Still this patch is good for correctness; thanks for pointing it out!
Thanks, applied.

						- Ted
