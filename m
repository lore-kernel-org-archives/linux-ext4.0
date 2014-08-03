From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/19] tests: add tests for directory entry blocks with
 checksum errors
Date: Sat, 2 Aug 2014 23:49:24 -0400
Message-ID: <20140803034924.GO24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181323.12496.25530.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42020 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068AbaHCDt0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 23:49:26 -0400
Content-Disposition: inline
In-Reply-To: <20140801181323.12496.25530.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:13:23AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add some regression tests to examine how e2fsck handles directory
> entry blocks and htree blocks with (a) malformed directory entries;
> (b) incorrect checksums; or (c) obviously garbage entries.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
