From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/8] ext4: store checksum seed in superblock
Date: Thu, 15 Oct 2015 10:45:29 -0400
Message-ID: <20151015144529.GH17329@thunk.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
 <20151012215444.28872.23113.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52052 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbbJOOpd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Oct 2015 10:45:33 -0400
Content-Disposition: inline
In-Reply-To: <20151012215444.28872.23113.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 12, 2015 at 02:54:44PM -0700, Darrick J. Wong wrote:
> Allow the filesystem to store the metadata checksum seed in the
> superblock and add an incompat feature to say that we're using it.
> This enables tune2fs to change the UUID on a mounted metadata_csum
> FS without having to (racy!) rewrite all disk metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
