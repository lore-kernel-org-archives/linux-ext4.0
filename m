From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 05/14] e2fsck: fix buffer overrun in revoke block
 scanning
Date: Sat, 16 May 2015 20:50:50 -0400
Message-ID: <20150517005050.GD4489@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002140.10785.5088.stgit@birch.djwong.org>
 <20150514193743.GH30577@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40759 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbbEQAuw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 May 2015 20:50:52 -0400
Content-Disposition: inline
In-Reply-To: <20150514193743.GH30577@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2015 at 12:37:43PM -0700, Darrick J. Wong wrote:
> Check the value of r_count to ensure that we never try to read revoke
> records past the end of the revoke block.  It turns out that the
> journal writing code in debugfs was also playing fast and loose with
> the r_count, so fix that as well.
> 
> The Coverity bug was 1297508.
> 
> v2: Allow the revoke block to use all slots, including the last
> one.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
