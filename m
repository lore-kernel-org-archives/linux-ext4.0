From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/21] libext2fs/e2fsck: don't run off the end of the EA
 block
Date: Sun, 10 Aug 2014 18:22:18 -0400
Message-ID: <20140810222218.GP15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010523.2611.3554.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53445 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaHJWWU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:22:20 -0400
Content-Disposition: inline
In-Reply-To: <20140805010523.2611.3554.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:05:23PM -0700, Darrick J. Wong wrote:
> When we're (a) reading EAs into a buffer; (b) byte-swapping EA
> entries; or (c) checking EA data, be careful not to run off the end of
> the memory buffer, because this causes invalid memory accesses and
> e2fsck crashes.  This can happen if we encounter a specially crafted
> FS image.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
