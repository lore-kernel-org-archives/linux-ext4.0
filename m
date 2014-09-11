From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] jbd2: fix journal checksum feature flag handling
Date: Thu, 11 Sep 2014 11:47:12 -0400
Message-ID: <20140911154712.GD26178@thunk.org>
References: <20140911002818.10109.51772.stgit@birch.djwong.org>
 <20140911002825.10109.80519.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51263 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaIKPrO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 11:47:14 -0400
Content-Disposition: inline
In-Reply-To: <20140911002825.10109.80519.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 10, 2014 at 05:28:25PM -0700, Darrick J. Wong wrote:
> Clear all three journal checksum feature flags before turning on
> whichever journal checksum options we want.  Rearrange the error
> checking so that newer flags get complained about first.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: TR Reardon <thomas_reardon@hotmail.com>

Thanks, applied.

					- Ted
