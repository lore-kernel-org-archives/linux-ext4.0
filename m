From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/21] e2fsck: convert 'delete files' warning to a proper
 fix_problem error
Date: Sun, 10 Aug 2014 18:16:57 -0400
Message-ID: <20140810221657.GN15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010510.2611.45729.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53428 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbaHJWQ6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:16:58 -0400
Content-Disposition: inline
In-Reply-To: <20140805010510.2611.45729.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:05:10PM -0700, Darrick J. Wong wrote:
> In pass 3, convert the "delete files and re-run e2fsck" message to a
> proper error code for more consistent error reporting and to make
> translation easier.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
