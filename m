From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/9] mke2fs: store checksum seed at format time
Date: Sat, 5 Mar 2016 19:19:52 -0500
Message-ID: <20160306001952.GE10297@thunk.org>
References: <20160213223725.25381.20929.stgit@birch.djwong.org>
 <20160213223751.25381.93488.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36512 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbcCFAT5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Mar 2016 19:19:57 -0500
Content-Disposition: inline
In-Reply-To: <20160213223751.25381.93488.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 13, 2016 at 02:37:51PM -0800, Darrick J. Wong wrote:
> Allow users to turn on metadata_csum_seed at format time so that UUIDs
> can be live-changed at any time.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
