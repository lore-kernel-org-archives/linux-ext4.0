From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 21/49] e2fsck: print runs of duplicate blocks instead of
 all of them
Date: Sat, 15 Mar 2014 12:19:17 -0400
Message-ID: <20140315161917.GD17270@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065612.30585.47051.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41808 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658AbaCOQTT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Mar 2014 12:19:19 -0400
Content-Disposition: inline
In-Reply-To: <20140311065612.30585.47051.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:56:12PM -0700, Darrick J. Wong wrote:
> When pass1 finds blocks that are mapped to multiple files, it will
> print every duplicated block.  If there are long sequences of
> duplicate blocks (e.g. the e_pblk field is wrong in an extent), this
> can cause a gigantic flood of output when a range could convey the
> same information.  Therefore, teach pass1b to print ranges when
> possible.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
