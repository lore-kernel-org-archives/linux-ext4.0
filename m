From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, REWORKED 01/11] Add initial checksum support for the
	gdt_checksum/uninit_group feature
Date: Mon, 17 Mar 2008 14:05:05 -0400
Message-ID: <20080317180505.GG8368@mit.edu>
References: <1205760527-14858-1-git-send-email-tytso@mit.edu> <1205760527-14858-2-git-send-email-tytso@mit.edu> <20080317172254.GF3542@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Jose R. Santos" <jrs@us.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43871 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752577AbYCQSF3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2008 14:05:29 -0400
Content-Disposition: inline
In-Reply-To: <20080317172254.GF3542@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 18, 2008 at 01:22:54AM +0800, Andreas Dilger wrote:
> On Mar 17, 2008  09:28 -0400, Theodore Ts'o wrote:
> > +STATIC __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
  ....
> > +	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
> > +		int offset = offsetof(struct ext2_group_desc, bg_checksum);
> > +
  ...
> > +		offset += sizeof(desc->bg_checksum); /* skip checksum */
> > +		assert(offset == sizeof(*desc));
> 
> Note that this assertion needs to be removed when the group descriptor
> becomes larger, unless ext2_group_desc never changes in the future..

Yeah, I looked at this, and was half tempted to remove it.

Indeed ext2_group_desc will never change in the future.  Too many
things would break if we change it.  That's why there is an
ext4_group_desc which looks exactly like ext2_group_desc for the first
32 bytes, and adds the high 32-bits for the various fields in the
second 32-bytes.

But if ext2_group_desc is never going to change, then there's no real
good reason to use a run-time check here.  Better to turn it into a
compile time check, using #error.  The tricky part is doing it in a
way which is ANSI-C compliant (or maybe we just wrap it in a #ifdef
GCC and only do the sanity check if you are compiling with GCC).

    	     	    	   	    - Ted
