From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/31] libext2fs: Add space for metadata checksum when
 unconverting a hashed directory block
Date: Sat, 12 Oct 2013 23:16:31 -0400
Message-ID: <20131013031631.GA22642@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012714.28415.87579.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45326 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab3JMDQd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Oct 2013 23:16:33 -0400
Content-Disposition: inline
In-Reply-To: <20131001012714.28415.87579.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:27:14PM -0700, Darrick J. Wong wrote:
> The ext2fs_link function has the unfortunate habit of converting hashed
> directories into unhashed directories.  It doesn't notice that it's slicing
> and dicing directory entries from a former dx_{root,node} block, and therefore
> doesn't write a protective dirent into the end of the block to store the
> checksum.  Teach it to do this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied to the next branch.

					- Ted
