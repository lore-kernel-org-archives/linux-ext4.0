From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/39] e2fuzz: exercise fuzzed blocks more aggressively
Date: Tue, 4 Nov 2014 11:36:37 -0500
Message-ID: <20141104163637.GC30614@thunk.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
 <20141025205636.532.23454.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38282 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbaKDQgk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 11:36:40 -0500
Content-Disposition: inline
In-Reply-To: <20141025205636.532.23454.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 25, 2014 at 01:56:36PM -0700, Darrick J. Wong wrote:
> Exercise fuzzed metadata blocks more aggressively by expanding up to
> 50000 files (instead of just test.1, which might not hit anything).
> Fix a typo while we're at it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
