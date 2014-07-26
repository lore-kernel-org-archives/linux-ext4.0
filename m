From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/18] e2fsck: fix merge error in "clear uninit flag on
 directory extents"
Date: Sat, 26 Jul 2014 16:04:07 -0400
Message-ID: <20140726200407.GK6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003351.28334.1044.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58618 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734AbaGZUEJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 16:04:09 -0400
Content-Disposition: inline
In-Reply-To: <20140726003351.28334.1044.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 05:33:51PM -0700, Darrick J. Wong wrote:
> In the original patch (against -next), the hunk to fix uninit dirs was
> just prior to the hunk labelled "Corrupt but passes checks?".  The
> hunks are ordered this way so that if e2fsck obtains permission to fix
> a failed-csum extent (which in turn fixes the checksum), it will not
> subsequently ask to (re)fix the checksum.
> 
> Due to a merge error the hunk moved to the wrong place, so put it
> back.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
