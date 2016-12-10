From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: reject inodes with negative size
Date: Sat, 10 Dec 2016 09:55:25 -0500
Message-ID: <20161210145525.pnrwrz37fyyz3327@thunk.org>
References: <20161206235740.GA16804@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41072 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751130AbcLJWtd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 10 Dec 2016 17:49:33 -0500
Content-Disposition: inline
In-Reply-To: <20161206235740.GA16804@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 06, 2016 at 03:57:40PM -0800, Darrick J. Wong wrote:
> Don't load an inode with a negative size; this causes integer overflow
> problems in the VFS.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.  I added a call to EXT4_ERROR_INODE() so the file
system would be marked corrupted.

				- Ted
