From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/27] misc: fix gcc warnings
Date: Sun, 24 Aug 2014 19:56:51 -0400
Message-ID: <20140824235651.GI6236@thunk.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
 <20140816234603.11171.57181.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47063 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbaHXX4w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Aug 2014 19:56:52 -0400
Content-Disposition: inline
In-Reply-To: <20140816234603.11171.57181.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 16, 2014 at 04:46:03PM -0700, Darrick J. Wong wrote:
> Fix a number of warnings about unneeded variables, uninitialized
> variables, and ignored return values.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This patch is identical to http://patchwork.ozlabs.org/patch/378713/,
which I've already applied.

					- Ted
