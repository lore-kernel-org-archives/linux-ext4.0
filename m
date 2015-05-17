From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/14] misc: fix undo file setup
Date: Sat, 16 May 2015 20:20:21 -0400
Message-ID: <20150517002021.GB4489@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002127.10785.17635.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40737 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbbEQAUW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 May 2015 20:20:22 -0400
Content-Disposition: inline
In-Reply-To: <20150514002127.10785.17635.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2015 at 05:21:27PM -0700, Darrick J. Wong wrote:
> Fix Coverity bugs 1297094-1297101 by fixing all the mutations in the
> *_setup_tdb() functions, fixing buffer overflows, and checking
> return values.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
