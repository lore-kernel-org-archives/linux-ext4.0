From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 19/19] tests: add regression tests for inodes with bad
 checksums
Date: Sat, 2 Aug 2014 23:52:37 -0400
Message-ID: <20140803035237.GS24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181349.12496.77562.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42044 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068AbaHCDwj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 23:52:39 -0400
Content-Disposition: inline
In-Reply-To: <20140801181349.12496.77562.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:13:49AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add regression tests to e2fsck to examine how it deals with inode
> table blocks which (a) have been zero'd; (b) have been one'd; (c) have
> corrupt inodes with obvious problems; and (d) have inodes with
> non-obvious problems.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
