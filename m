From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 22/35] tests: test various features of the new e2undo
 format
Date: Tue, 5 May 2015 10:44:02 -0400
Message-ID: <20150505144402.GI9260@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023624.25243.81889.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45927 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993232AbbEEOoC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:44:02 -0400
Content-Disposition: inline
In-Reply-To: <20150402023624.25243.81889.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:36:24PM -0700, Darrick J. Wong wrote:
> Verify that the header, checksum, and wrong-order rollback detection
> features of the new e2undo actually work.
> 
> v2: Collect more tests for the v2 of the e2undo flat file patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

				- Ted
