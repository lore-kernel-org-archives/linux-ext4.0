From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/19] tests: add regression tests for EA blocks with bad
 checksums
Date: Sat, 2 Aug 2014 23:42:11 -0400
Message-ID: <20140803034211.GM24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181307.12496.76118.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42007 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbaHCDmP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 23:42:15 -0400
Content-Disposition: inline
In-Reply-To: <20140801181307.12496.76118.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:13:07AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add regression tests for e2fsck dealing with (a) EA block with a bad
> checksum; (b) EA block with a bad magic number; and (c) EA block with
> damage that isn't otherwise noticeable.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
