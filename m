From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/34] debugfs: manage needs_recover feature when messing
 with the journal
Date: Fri, 19 Sep 2014 02:01:56 -0400
Message-ID: <20140919060156.GK26995@thunk.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221145.13646.30513.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36983 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbaISGCB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Sep 2014 02:02:01 -0400
Content-Disposition: inline
In-Reply-To: <20140913221145.13646.30513.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2014 at 03:11:45PM -0700, Darrick J. Wong wrote:
> Set the needs_recover incompat feature when debugfs writes journal
> transactions so that we actually replay the journal contents at the
> next mount.
> 
> Likewise, clear it if we successfully recover the journal.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
