From: tytso@mit.edu
Subject: Re: [PATCH] resize: check s_log_groups_per_flex before accessing
 flex groups
Date: Sat, 3 Apr 2010 22:11:01 -0400
Message-ID: <20100404021101.GD18524@thunk.org>
References: <4BAE5D40.5050809@redhat.com>
 <96C33B08-CDC5-48B3-98C0-479F230E7F98@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Alessandro Polverini <alex@nibbles.it>,
	Christoph Biedl <bugzilla.kernel.bpeb@manchmal.in-ulm.de>
To: Andreas Dilger <andreas.dilger@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57999 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab0DDCLY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Apr 2010 22:11:24 -0400
Content-Disposition: inline
In-Reply-To: <96C33B08-CDC5-48B3-98C0-479F230E7F98@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 28, 2010 at 09:14:07AM -0600, Andreas Dilger wrote:
> On 2010-03-27, at 13:32, Eric Sandeen wrote:
> >#13549, Kernel oops while online resizing of an ext4 filesystem
> >
> >if groups_per_flex < 2, sbi->s_flex_groups[] doesn't get filled out,
> >and every other access to this first tests s_log_groups_per_flex;
> >same thing needs to happen in resize or we'll wander off into
> >a null pointer.
> 
> Does it even make sense to set INCOMPAT_FLEX_BG if we only have a
> single group per flexbg?  That is just a normal filesystem then.
> That would be a separate bug in mke2fs.

Yes, it does make sense to set flex_bg in this case; it allows the
group metadata to be stored outside of a blockgroup, which is helpful
to e2fsck in some cases when it needs to relocate an inode table and
there's no contiguous free space available in the block group.

	   	      	   	 	   - Ted
