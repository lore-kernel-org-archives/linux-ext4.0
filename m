From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 8/9] tune2fs: recover the journal
Date: Sun, 6 Mar 2016 00:23:43 -0500
Message-ID: <20160306052343.GJ10297@thunk.org>
References: <20160213223725.25381.20929.stgit@birch.djwong.org>
 <20160213223817.25381.99799.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36922 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbcCFFXq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2016 00:23:46 -0500
Content-Disposition: inline
In-Reply-To: <20160213223817.25381.99799.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 13, 2016 at 02:38:17PM -0800, Darrick J. Wong wrote:
> If the journal needs to be recovered to avoid clobbering whatever
> changes tune2fs makes, do so.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

							- Ted
