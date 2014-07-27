From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/18] e2fsck: clear badblocks inode when checksum fails
Date: Sun, 27 Jul 2014 19:42:44 -0400
Message-ID: <20140727234244.GB6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003512.28334.62413.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59602 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbaG0Xms (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jul 2014 19:42:48 -0400
Content-Disposition: inline
In-Reply-To: <20140726003512.28334.62413.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 05:35:12PM -0700, Darrick J. Wong wrote:
> If the badblocks inode fails checksum verification, just clear the
> inode and move on.  If we don't do this, we can end up importing a lot
> of garbage into the badblocks list, which will then cause fsck to try
> to regenerate anything that was sitting atop the supposedly damaged
> blocks.  Given that most hardware will remap bad sectors transparently
> from ext4, the number of people this could affect adversely is pretty
> low.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
