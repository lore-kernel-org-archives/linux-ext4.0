From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/19] tests: add tests for handling of corrupt extents
Date: Sat, 2 Aug 2014 23:47:38 -0400
Message-ID: <20140803034738.GN24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181314.12496.3254.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42014 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbaHCDrj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 23:47:39 -0400
Content-Disposition: inline
In-Reply-To: <20140801181314.12496.3254.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:13:14AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add some regression tests to examine how e2fsck deals with (a) extent
> blocks with only a bad checksum; (b) extent blocks with a bad magic
> number; and (c) extent entries with corruption.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
