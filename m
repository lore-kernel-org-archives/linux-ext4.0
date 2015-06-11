From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/14] libext2fs: implement fallocate
Date: Wed, 10 Jun 2015 20:09:11 -0400
Message-ID: <20150611000911.GE24181@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002213.10785.16325.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58959 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbbFKCmx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2015 22:42:53 -0400
Content-Disposition: inline
In-Reply-To: <20150514002213.10785.16325.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2015 at 05:22:13PM -0700, Darrick J. Wong wrote:
> Create a library function to perform fallocation on arbitrary files,
> and wire up a few users for this function.  This is a bit more intense
> than Ted's original mk_hugefiles implementation since we have to honor
> any blocks that may already be allocated to the file.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
