From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/19] tests: add regression tests for superblocks with
 bad checksums
Date: Sat, 2 Aug 2014 23:50:46 -0400
Message-ID: <20140803035046.GQ24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181336.12496.46953.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42032 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068AbaHCDur (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 23:50:47 -0400
Content-Disposition: inline
In-Reply-To: <20140801181336.12496.46953.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:13:36AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add regression tests to examine how e2fsck deals with random
> superblock corruption such as obviously wrong fields and the checksum
> itself being incorrect.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
