From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [EXT4 set 7][PATCH 1/1]Remove 32000 subdirs limit.
Date: Wed, 11 Jul 2007 06:45:34 -0600
Message-ID: <20070711124534.GA6417@schatzie.adilger.int>
References: <1183275498.4010.135.camel@localhost.localdomain> <20070710224011.e60b9864.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:36509 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761426AbXGKMpg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 08:45:36 -0400
Content-Disposition: inline
In-Reply-To: <20070710224011.e60b9864.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 10, 2007  22:40 -0700, Andrew Morton wrote:
> On Sun, 01 Jul 2007 03:38:18 -0400 Mingming Cao <cmm@us.ibm.com> wrote:
> > A EXT4_FEATURE_RO_COMPAT_DIR_NLINK flag has been added and it is set if
> > the subdir count for any directory crosses 65000.
> 
> Would I be correct in assuming that a later fsck will clear
> EXT4_FEATURE_RO_COMPAT_DIR_NLINK if there are no longer any >65000 subdir
> directories?

Correct.

> If so, that is worth a mention in the changelog, perhaps?
> 
> Please remind us what is the behaviour of an RO_COMPAT flag?  It means that
> old ext4, ext3 and ext2 can only mount this fs read-only, yes?

Also correct.  The COMPAT flag behaviour is described in detail in
Documentation/filesystems/ext[234].txt

> > +static inline void ext4_inc_count(handle_t *handle, struct inode *inode)
> > +{
> > +	inc_nlink(inode);
> > +	if (is_dx(inode) && inode->i_nlink > 1) {
> > +		/* limit is 16-bit i_links_count */
> > +		if (inode->i_nlink >= EXT4_LINK_MAX || inode->i_nlink == 2) {
> > +			inode->i_nlink = 1;
> > +			EXT4_SET_RO_COMPAT_FEATURE(inode->i_sb,
> > +					      EXT4_FEATURE_RO_COMPAT_DIR_NLINK);
> > +		}
> > +	}
> > +}
> 
> Why do we set EXT4_FEATURE_RO_COMPAT_DIR_NLINK if i_nlink==2?

Because that means it was previously 1 (inc_nlink() was already called).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
