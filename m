From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/14] filefrag: fix broken extent emulation and
 uninitialized variables
Date: Sat, 16 May 2015 20:26:03 -0400
Message-ID: <20150517002603.GC4489@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002134.10785.61003.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40744 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbbEQA0E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 May 2015 20:26:04 -0400
Content-Disposition: inline
In-Reply-To: <20150514002134.10785.61003.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2015 at 05:21:34PM -0700, Darrick J. Wong wrote:
> This started with the fm_ext being uninitialized, but upon closer
> analysis I discovered that forcing extent emulation in FIBMAP mode
> was reporting an extent for every block in the file.  Fix both
> problems.
> 
> The Coverity bug was 1297512.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
