From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 19/47] e2fsck: don't complain about root dir csum
 failures when getting lnf
Date: Sat, 13 Dec 2014 21:57:09 -0500
Message-ID: <20141214025709.GH29787@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215251.883.27455.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54856 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbaLNC5K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Dec 2014 21:57:10 -0500
Content-Disposition: inline
In-Reply-To: <20141107215251.883.27455.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:52:51PM -0800, Darrick J. Wong wrote:
> Don't complain about checksum failures on the root dir when we're
> trying to find l+f if the root dir is going to be rehashed anyway.
> 
> The test case for this is t_enable_mcsum in the next patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
