From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 7/7] libext2fs: enforce the block group descriptor size
 in ext2fs_open()
Date: Tue, 31 Jul 2012 16:09:18 -0400
Message-ID: <20120731200918.GF32228@thunk.org>
References: <20120628024356.GB17989@thor.bakeyournoodle.com>
 <1343684862-13181-1-git-send-email-tytso@mit.edu>
 <1343684862-13181-7-git-send-email-tytso@mit.edu>
 <B4B1A06B-F856-4248-8A7E-3BFF8F3E7267@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"tony@bakeyournoodle.com" <tony@bakeyournoodle.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42364 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab2GaUJU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 16:09:20 -0400
Content-Disposition: inline
In-Reply-To: <B4B1A06B-F856-4248-8A7E-3BFF8F3E7267@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 31, 2012 at 11:38:47AM -0700, Andreas Dilger wrote:
> > +    /* Enforce the block group descriptor size */
> > +    if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) {
> > +        if (fs->super->s_desc_size != EXT2_MIN_DESC_SIZE_64BIT) {
> 
> It doesn't necessarily make sense to limit this to the minimum size, only that it is at least the minimum size. 

I'm not at all convinced that the ext2fs library will do the right
thing if the block group size is larger than what we expect.  At the
very least we need to make sure it is a power of two, but even so I'd
want to audit the code and do some experiments before I would hang my
hat on this actually working correctly...

					- Ted
