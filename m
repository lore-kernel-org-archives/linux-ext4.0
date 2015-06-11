From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 16/14] libext2fs: require the inline data xattr on all
 inline data files
Date: Wed, 10 Jun 2015 20:15:30 -0400
Message-ID: <20150611001530.GK24181@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150605013856.GA7063@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58960 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbbFKCmx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2015 22:42:53 -0400
Content-Disposition: inline
In-Reply-To: <20150605013856.GA7063@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 04, 2015 at 06:38:56PM -0700, Darrick J. Wong wrote:
> Turns out that the kernel requires the inline data xattr to exist for
> all inline data files, even if the inline data size is zero.
> Therefore, never delete the xattr key, and teach e2fsck always to look
> for it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

It seems reasonable to have e2fsck look for this case, but I wonder if
it might be better to fix it by changing the kernel and e2fsck and
libext2fs's punch function to clear the inline data flag when it
removes the inline data xattr, and to do so if the xattr data size is
zero.

							- Ted
