From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/19] e2fsck: try to salvage corrupt directory entry
 blocks
Date: Sat, 2 Aug 2014 22:33:34 -0400
Message-ID: <20140803023334.GG24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181228.12496.58789.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41937 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbaHCCdf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 22:33:35 -0400
Content-Disposition: inline
In-Reply-To: <20140801181228.12496.58789.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:12:28AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove the code that would prompt the user to zap directory entry
> blocks with bad checksums (i.e. strict_csums).  Instead, we'll run the
> directory entries through the usual repair routines in an attempt to
> save whatever we can.  At the same time, refactor the code that
> schedules the repair of missing dirblock checksum entries.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
