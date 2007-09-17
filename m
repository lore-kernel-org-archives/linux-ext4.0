From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] ext34: ensure do_split leaves enough free space in both blocks
Date: Mon, 17 Sep 2007 14:57:38 -0600
Message-ID: <20070917205738.GQ2990@schatzie.adilger.int>
References: <46EEA5F4.3030806@redhat.com> <46EEB7A4.9040903@sandeen.net> <20070917133020.5fc4650c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	hooanon05@yahoo.co.jp, Theodore Ts'o <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:48362 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764AbXIQU5O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Sep 2007 16:57:14 -0400
Content-Disposition: inline
In-Reply-To: <20070917133020.5fc4650c.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 17, 2007  13:30 -0700, Andrew Morton wrote:
> On Mon, 17 Sep 2007 12:21:40 -0500
> > Eric Sandeen wrote:
> > > The do_split() function for htree dir blocks is intended to split a
> > > leaf block to make room for a new entry.  It sorts the entries in the
> > > original block by hash value, then moves the last half of the entries to 
> > > the new block - without accounting for how much space this actually moves.  
> > > (IOW, it moves half of the entry *count* not half of the entry *space*).
> > > If by chance we have both large & small entries, and we move only the 
> > > smallest entries, and we have a large new entry to insert, we may not have 
> > > created enough space for it.
> > 
> > (btw, the upshot of this is that in add_dirent_to_buf(),
> > memcpy(de->name, name, namelen) will overshoot the buffer and actually
> > corrupt memory.)
> 
> So this looks like 2.6.22 and 2.6.23 material, but the timing is getting
> pretty squeezy.  Could people please give this change an extra-close
> review, let me know?

I already discussed it at length with Eric and inspected the patch, so we
could add:
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

Haven't actually tested the code myself.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
