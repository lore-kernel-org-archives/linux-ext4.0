From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 40/39] e2fsck: fix reporting of unknown htree block inode
 number
Date: Wed, 5 Nov 2014 11:11:20 -0500
Message-ID: <20141105161120.GB27083@thunk.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
 <20141027233109.GE10057@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Sami Liedes <sami.liedes@iki.fi>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40325 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbaKEQL0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Nov 2014 11:11:26 -0500
Content-Disposition: inline
In-Reply-To: <20141027233109.GE10057@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 27, 2014 at 04:31:09PM -0700, Darrick J. Wong wrote:
> Sami Liedes reports that e2fsck fails to report the correct directory
> inode number during a pass2 check for unexpected HTREE blocks.
> Provide the inode number in the problem report.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Sami Liedes <sami.liedes@iki.fi>

Applied, thanks.

					- Ted
