From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: recognize ext4(dev) without journal
Date: Sun, 8 Mar 2009 19:22:39 -0400
Message-ID: <20090308232239.GA5578@mit.edu>
References: <49A4D482.7000900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45868 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbZCIDbk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Mar 2009 23:31:40 -0400
Content-Disposition: inline
In-Reply-To: <49A4D482.7000900@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 24, 2009 at 11:17:54PM -0600, Eric Sandeen wrote:
> ext4/ext4dev no longer require a journal.
> 
> w/o this blkid doesn't recognize after:
> 
> # mkfs.ext4 /dev/blah
> # tune2fs -O ^has_journal
> # blkid /dev/blah
> 
> We still must have one ext3-incompat-feature to flag
> as ext4(dev) so we shouldn't ever mis-recognize it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied to the e2fsprogs git tree.

						- Ted
