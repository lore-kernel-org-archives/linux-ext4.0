From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/49] create_inode: handle hard link inum mappings per
 populate_fs invocation
Date: Tue, 11 Mar 2014 23:46:11 -0400
Message-ID: <20140312034611.GD26898@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065430.30585.46364.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40231 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbaCLDqV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2014 23:46:21 -0400
Content-Disposition: inline
In-Reply-To: <20140311065430.30585.46364.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:54:30PM -0700, Darrick J. Wong wrote:
> When calling populate_fs, the map for hardlink detection is not
> cleaned up between populate_fs invocations, which could lead to
> unexpected results if anyone calls populate_fs twice in the same
> client program).  This doesn't happen right now, but we might as well
> clean it up.
> 
> The detctor fails if the external directory crosses mountpoints,
> so fix that too.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
