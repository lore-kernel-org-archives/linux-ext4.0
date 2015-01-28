From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 18/54] e2fsck: improve the inline directory detector
Date: Wed, 28 Jan 2015 11:38:23 -0500
Message-ID: <20150128163823.GR2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073730.13308.10353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42248 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522AbbA2CFr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Jan 2015 21:05:47 -0500
Content-Disposition: inline
In-Reply-To: <20150127073730.13308.10353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:37:31PM -0800, Darrick J. Wong wrote:
> Strengthen the checks that guess if the inode we're looking at is an
> inline directory.  The current check sweeps up any inline inode if
> its length is a multiple of four; now we'll at least try to see if
> there's the beginning of a valid directory entry.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
