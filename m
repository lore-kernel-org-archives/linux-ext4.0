From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 23/47] mke2fs: don't zero inode table blocks that are
 already zeroed
Date: Sat, 13 Dec 2014 22:01:31 -0500
Message-ID: <20141214030131.GL29787@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215316.883.99673.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54881 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbaLNDBc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Dec 2014 22:01:32 -0500
Content-Disposition: inline
In-Reply-To: <20141107215316.883.99673.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:53:16PM -0800, Darrick J. Wong wrote:
> At mke2fs time, if we discard the device and discard zeroes data,
> don't bother zeroing the inode table blocks a second time.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
