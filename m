From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/31] Define an error code for block bitmap checksum
 failures
Date: Sat, 12 Oct 2013 23:12:34 -0400
Message-ID: <20131013031234.GB28064@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012702.28415.85146.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45322 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab3JMDMg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Oct 2013 23:12:36 -0400
Content-Disposition: inline
In-Reply-To: <20131001012702.28415.85146.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:27:02PM -0700, Darrick J. Wong wrote:
> Apparently libext2fs didn't have an error code defined for block bitmap
> checksum errors, so add one.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
