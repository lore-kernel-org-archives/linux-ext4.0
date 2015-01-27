From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/54] e2fsck: clear i_block[] when there are too many
 bad mappings on a special inode
Date: Tue, 27 Jan 2015 11:32:38 -0500
Message-ID: <20150127163238.GL2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073650.13308.34112.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35404 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbbA0Qcm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 11:32:42 -0500
Content-Disposition: inline
In-Reply-To: <20150127073650.13308.34112.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:36:50PM -0800, Darrick J. Wong wrote:
> If we decide to clear a special inode because of bad mappings, we need
> to zero the i_block array.  The clearing routine depends on setting
> i_links_count to zero to keep us from re-checking the block maps,
> but that field isn't checked for special inodes.  Therefore, if we
> haven't erased the mappings, check_blocks will restart fsck and fsck
> will try to check the blocks again, leading to an infinite loop.
> 
> (This seems easy to trigger if the bootloader inode extent map is
> corrupted.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
