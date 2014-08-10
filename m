From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 10/21] e2fsck: clear inline_data inode flag if EA
 missing
Date: Sun, 10 Aug 2014 18:37:45 -0400
Message-ID: <20140810223745.GV15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010602.2611.64599.stgit@birch.djwong.org>
 <20140808224448.GG11191@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53491 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaHJWhr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:37:47 -0400
Content-Disposition: inline
In-Reply-To: <20140808224448.GG11191@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 08, 2014 at 03:44:48PM -0700, Darrick J. Wong wrote:
> If i_size indicates that an inode requires a system.data extended
> attribute to hold overflow from i_blocks but the EA cannot be found,
> offer to truncate the file.
> 
> v2: Use the raw xattr editing interface since it'll return error codes
> to us directly.  This is a side effect of modifying the library inline
> data code not to return "key error" when it can't find the system.data
> EA.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
