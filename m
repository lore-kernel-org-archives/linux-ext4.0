From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/31] e2fsprogs: Fix blk_t <- blk64_t assignment
 mismatches
Date: Mon, 7 Oct 2013 09:52:21 -0400
Message-ID: <20131007135221.GI4540@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012759.28415.27498.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43101 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab3JGNwY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Oct 2013 09:52:24 -0400
Content-Disposition: inline
In-Reply-To: <20131001012759.28415.27498.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:27:59PM -0700, Darrick J. Wong wrote:
> Fix all the places where we should be using a blk64_t instead of a blk_t.
> These fixes are more severe because 64bit values could be truncated silently.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied to the maint branch, thanks.

					- Ted
