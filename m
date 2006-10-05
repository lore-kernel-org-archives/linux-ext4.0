From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 compat flag assignments
Date: Wed, 4 Oct 2006 22:02:15 -0400
Message-ID: <20061005020215.GD19647@thunk.org>
References: <20060922091520.GC6335@schatzie.adilger.int> <20060928085515.GC27104@openx1.frec.bull.fr> <20061004200440.GB1656@thunk.org> <20061005001906.GN22010@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:3037 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751324AbWJECCR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Oct 2006 22:02:17 -0400
To: Andreas Dilger <adilger@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <20061005001906.GN22010@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 04, 2006 at 06:19:06PM -0600, Andreas Dilger wrote:
> Good question, I don't know that it is.  Even if the journal was extent
> mapped (possible, but would need support in e2fsprogs for this) the
> data would be stored in the same sized i_blocks array.

That won't be too hard.  The e2fsprogs code is designed to be
identical to the kernel code, so we just drop in a new version of
fs/ext3/recovery.c that understands extents into e2fsck/recovery.c,
and e2fsprogs will have support.  :-)

						- Ted
