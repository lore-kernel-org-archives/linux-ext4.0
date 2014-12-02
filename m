From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: fix regression where we fail to initialize
 checksum seed when loading
Date: Mon, 1 Dec 2014 22:05:55 -0500
Message-ID: <20141202030555.GA953@thunk.org>
References: <20141202002223.GT10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33441 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbaLBDIF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Dec 2014 22:08:05 -0500
Content-Disposition: inline
In-Reply-To: <20141202002223.GT10043@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 01, 2014 at 04:22:23PM -0800, Darrick J. Wong wrote:
> When we're enabling journal features, we cannot use the predicate
> jbd2_journal_has_csum_v2or3() because we haven't yet set the sb
> feature flag fields!  Moreover, we just finished loading the shash
> driver, so the test is unnecessary; calculate the seed always.
> 
> Without this patch, we fail to initialize the checksum seed the first
> time we turn on journal_checksum, which means that all journal blocks
> written during that first mount are corrupt.  Transactions written
> after the second mount will be fine, since the feature flag will be
> set in the journal superblock.  xfstests generic/{034,321,322} are the
> regression tests.
> 
> (This is important for 3.18.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.coM>
> Reported-by: Eric Whitney <enwlinux@gmail.com>

Applied, thanks.  I've confirmed this has fixed the xfstests
regressions, and I'll be sending this to Linus shortly.

	     	      	 	      - Ted
