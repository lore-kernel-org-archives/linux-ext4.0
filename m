From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/19] e2fuzz: fix fs handle cleanup when closing fails
Date: Sat, 2 Aug 2014 22:22:32 -0400
Message-ID: <20140803022232.GA24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181146.12496.33396.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41900 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaHCCWg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 22:22:36 -0400
Content-Disposition: inline
In-Reply-To: <20140801181146.12496.33396.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:11:46AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix the handling of 'fs' when closing the FS fails so that we don't
> dereference a NULL pointer.  Adapt to use ext2fs_close_free while
> we're at it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Fixes-Coverity-Bug: 1229241

Applied, thanks.

						- Ted
