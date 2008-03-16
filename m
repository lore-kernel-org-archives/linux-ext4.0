From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][10/28] e2fsprogs-uninit.patch
Date: Sun, 16 Mar 2008 08:34:53 +0800
Message-ID: <20080316003453.GX3542@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
 <20080202083444.GK31694@webber.adilger.int> <20080315194120.GI27847@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:38227 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYCPAfZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Mar 2008 20:35:25 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2G0ZP7X011634
	for <linux-ext4@vger.kernel.org>; Sat, 15 Mar 2008 17:35:25 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXS00G01S2JJU00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 15 Mar 2008 17:35:25 -0700 (PDT)
In-reply-to: <20080315194120.GI27847@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 15, 2008  15:41 -0400, Theodore Ts'o wrote:
> What is the intended use of the SF_DO_CSUM flag?  I see where it is
> defined, and where it gets sets, but as far as I can tell nothing
> actually tests for it or uses it.

Probably a hold-over from a previous version of the code.  It sets the
SF_DO_LAZY flag if GDT_CSUM is set, causing ext2fs_get_next_inode_full()
to skip the BG_INODE_UNINT groups.  It's up to you if it would be better
to keep SF_DO_CSUM and check for it explicitly (possibly using it for
something else later), or to overload SF_DO_LAZY as we do currently.

> On Sat, Feb 02, 2008 at 01:34:44AM -0700, Andreas Dilger wrote:
> > Index: e2fsprogs-1.40.5/lib/ext2fs/ext2fs.h
> >
> > +#define EXT2_SF_DO_CSUM		0x0020
> >
> 
> > Index: e2fsprogs-1.40.5/lib/ext2fs/inode.c
> > ===================================================================
> > --- e2fsprogs-1.40.5.orig/lib/ext2fs/inode.c
> > +++ e2fsprogs-1.40.5/lib/ext2fs/inode.c
> > @@ -167,6 +167,9 @@ errcode_t ext2fs_open_inode_scan(ext2_fi
> >  	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
> >  				    EXT2_FEATURE_COMPAT_LAZY_BG))
> >  		scan->scan_flags |= EXT2_SF_DO_LAZY;
> > +	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> > +				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
> > +		scan->scan_flags |= EXT2_SF_DO_LAZY | EXT2_SF_DO_CSUM;

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

