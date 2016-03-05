From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/9] libext2fs: store checksum seed in superblock
Date: Sat, 5 Mar 2016 18:21:31 -0500
Message-ID: <20160305232131.GB10297@thunk.org>
References: <20160213223725.25381.20929.stgit@birch.djwong.org>
 <20160213223732.25381.26638.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36410 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbcCEXVg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Mar 2016 18:21:36 -0500
Content-Disposition: inline
In-Reply-To: <20160213223732.25381.26638.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 13, 2016 at 02:37:32PM -0800, Darrick J. Wong wrote:
> Allow the filesystem to store the metadata checksum seed in the
> superblock and add an incompat feature to say that we're using it.
> This enables tune2fs to change the UUID on a mounted metadata_csum
> FS without having to (racy!) rewrite all disk metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
