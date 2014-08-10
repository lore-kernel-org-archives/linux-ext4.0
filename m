From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/21] e2fsck: don't try to iterate blocks of an
 inline_data inode when deallocating it
Date: Sun, 10 Aug 2014 18:40:33 -0400
Message-ID: <20140810224033.GY15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010622.2611.77018.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53504 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaHJWkf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:40:35 -0400
Content-Disposition: inline
In-Reply-To: <20140805010622.2611.77018.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:06:22PM -0700, Darrick J. Wong wrote:
> Inodes with inline_data set do not have iterable blocks, so don't try
> to iterate the blocks, because that will just fail, causing e2fsck to
> abort.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
