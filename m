From: Jan Kara <jack@suse.cz>
Subject: Re: ext3/jbd: Avoid WARN() messages when failing to write the
	superblock
Date: Mon, 11 Oct 2010 17:17:48 +0200
Message-ID: <20101011151748.GI3830@quack.suse.cz>
References: <20101004193505.GC25624@tux1.beaverton.ibm.com>
 <4CB327BE.8000003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: djwong@us.ibm.com, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669Ab0JKPSv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Oct 2010 11:18:51 -0400
Content-Disposition: inline
In-Reply-To: <4CB327BE.8000003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 11-10-10 10:05:34, Eric Sandeen wrote:
> Darrick J. Wong wrote:
> > This fixes a WARN backtrace in mark_buffer_dirty() that occurs during unmount
> > when the underlying block device is removed.  This bug has been seen on System
> > Z when removing all paths from a multipath-backed ext3 mount; on System P when
> > injecting enough PCI EEH errors to make the SCSI controller go offline; and
> > similar warnings have been seen (and patched) with ext2/ext4.
> > 
> > The super block update from a previous operation has marked the buffer as in
> > error, and the flag has to be cleared before doing the update.  (Similar code
> > already exists in ext4).
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> 
> Probably worth mentioning the ext4 version is:
> 
> commit 914258bf2cb22bf4336a1b1d90c551b4b11ca5aa
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Mon Oct 6 21:35:40 2008 -0400
> 
>     ext4/jbd2: Avoid WARN() messages when failing to write to the superblock
>     
>     This fixes some very common warnings reported by kerneloops.org
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
  Yup. Done. Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
