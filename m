From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/49] e2fsck: zero errcode when checking inline data
 blocks
Date: Fri, 14 Mar 2014 09:26:58 -0400
Message-ID: <20140314132658.GF8282@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065508.30585.30041.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41335 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbaCNN1A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2014 09:27:00 -0400
Content-Disposition: inline
In-Reply-To: <20140311065508.30585.30041.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:55:08PM -0700, Darrick J. Wong wrote:
> When checking inline data blocks, always zero pctx->errcode because
> otherwise a previous error condition could leak through and "cause" a
> fatal block iteration failure.  I found this by corrupting an xattr
> block on an inline_data inode and fsck aborted when I tried to repair
> it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
