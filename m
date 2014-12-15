From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 36/47] tests: test resize2fs 32->64 and 64->32bit
 conversion code
Date: Mon, 15 Dec 2014 12:46:36 -0500
Message-ID: <20141215174636.GD21646@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215439.883.65839.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57234 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaLORqi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2014 12:46:38 -0500
Content-Disposition: inline
In-Reply-To: <20141107215439.883.65839.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:54:39PM -0800, Darrick J. Wong wrote:
> Add some simple tests to check that flex_bg and meta_bg filesystems
> can be converted between 32 and 64bit layouts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
