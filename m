From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/39] e2fsck: fix dangling pointer when dir_info array
 is resized
Date: Wed, 5 Nov 2014 11:12:53 -0500
Message-ID: <20141105161253.GC27083@thunk.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
 <20141025205812.532.67790.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sami Liedes <sami.liedes@iki.fi>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40335 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbaKEQM7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Nov 2014 11:12:59 -0500
Content-Disposition: inline
In-Reply-To: <20141025205812.532.67790.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 25, 2014 at 01:58:12PM -0700, Darrick J. Wong wrote:
> e2fsck uses an array to store directory usage information during pass
> 3; the usage context also contains a pointer to the last directory
> looked up.  When expanding the dir_info array, this cache pointer
> needs to be cleared if the array resize changed the pointer location,
> or else we'll later walk off the end of this dead pointer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Sami Liedes <sami.liedes@iki.fi>

Applied, thanks.

					- Ted
