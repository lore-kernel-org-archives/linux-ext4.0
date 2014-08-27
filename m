From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/27] contrib: add script to help resync journal code
 with kernel
Date: Tue, 26 Aug 2014 23:44:25 -0400
Message-ID: <20140827034425.GR11317@thunk.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
 <20140816234635.11171.50609.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51063 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbaH0Doc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Aug 2014 23:44:32 -0400
Content-Disposition: inline
In-Reply-To: <20140816234635.11171.50609.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 16, 2014 at 04:46:35PM -0700, Darrick J. Wong wrote:
> Add a script that handles (most) of the code massaging necessary to resync
> {recovery,revoke}.c from the Linux kernel into e2fsprogs.
> 
> Usage: jbd2-resync.sh linux/fs/jbd2/revoke.c e2fsprogs/e2fsck/revoke.c
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
