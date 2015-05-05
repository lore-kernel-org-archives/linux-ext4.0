From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 23/35] copy-in: create hardlinks with the correct
 directory filetype
Date: Tue, 5 May 2015 10:46:40 -0400
Message-ID: <20150505144640.GJ9260@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023630.25243.38189.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45931 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993241AbbEEOqk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:46:40 -0400
Content-Disposition: inline
In-Reply-To: <20150402023630.25243.38189.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:36:30PM -0700, Darrick J. Wong wrote:
> When we're creating hard links via ext2fs_link, the (misnamed?) flags
> argument specifies the filetype for the directory entry.  This is
> *derived* from i_mode, so provide a translator.  Otherwise, fsck will
> complain about unset file types.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
