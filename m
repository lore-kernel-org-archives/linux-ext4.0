From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/12] e2fsck: clean up feature test macros with
 predicate functions
Date: Sat, 24 Oct 2015 00:49:17 -0400
Message-ID: <20151024044917.GL7917@thunk.org>
References: <20151012215629.29065.24418.stgit@birch.djwong.org>
 <20151012215654.29065.20743.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41823 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbbJXKvf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Oct 2015 06:51:35 -0400
Content-Disposition: inline
In-Reply-To: <20151012215654.29065.20743.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 12, 2015 at 02:56:54PM -0700, Darrick J. Wong wrote:
> Create separate predicate functions to test/set/clear feature flags,
> thereby replacing the wordy old macros.  Furthermore, clean out the
> places where we open-coded feature tests.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
