From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix possible use after free of buffer head
Date: Thu, 29 Nov 2012 21:21:50 -0500
Message-ID: <20121130022150.GC24765@thunk.org>
References: <1354185828-28545-1-git-send-email-lczerner@redhat.com>
 <20121129190239.GA2888@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	stable@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35981 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158Ab2K3Fxa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Nov 2012 00:53:30 -0500
Content-Disposition: inline
In-Reply-To: <20121129190239.GA2888@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 29, 2012 at 11:02:39AM -0800, Darrick J. Wong wrote:
> On Thu, Nov 29, 2012 at 11:43:48AM +0100, Lukas Czerner wrote:
> > Commit fa77dcfafeaa6bc73293c646bfc3d5192dcf0be2 introduces block bitmap
> > checksum calculation into ext4_new_inode() in the case that block group
> > was uninitialized. However we brelse() the bitmap buffer before we
> > attempt to checksum it so we have no guarantee that the buffer is still
> > there.
> > 
> > Fix this by releasing the buffer after the possible checksum
> > computation.
> 
> Looks ok, so:
> Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
