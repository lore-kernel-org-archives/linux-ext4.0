From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 7/8] ext4: clean up feature test macros with predicate
 functions
Date: Thu, 15 Oct 2015 11:12:28 -0400
Message-ID: <20151015151228.GK17329@thunk.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
 <20151012215505.28872.1376.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52128 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbbJOPMb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Oct 2015 11:12:31 -0400
Content-Disposition: inline
In-Reply-To: <20151012215505.28872.1376.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 12, 2015 at 02:55:05PM -0700, Darrick J. Wong wrote:
> Create separate predicate functions to test/set/clear feature flags,
> thereby replacing the wordy old macros.  Furthermore, clean out the
> places where we open-coded feature tests.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
