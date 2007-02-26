From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] [PATCH 1/1] nanosecond timestamps
Date: Mon, 26 Feb 2007 14:42:15 -0700
Message-ID: <20070226214215.GE10715@schatzie.adilger.int>
References: <1170427180.6086.17.camel@garfield> <20070225023651.8c89f8fc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sct@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:32827 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161228AbXBZVmS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Feb 2007 16:42:18 -0500
Content-Disposition: inline
In-Reply-To: <20070225023651.8c89f8fc.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Feb 25, 2007  02:36 -0800, Andrew Morton wrote:
> > On Fri, 02 Feb 2007 20:09:40 +0530 Kalpak Shah <kalpak@clusterfs.com> wrote:
> > +#define EXT3_INODE_GET_XTIME(xtime, extra_xtime, inode, raw_inode)
> > \
> > +do {
> > \
> > +	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);
> > \
> > +									      \
> > +	if (offsetof(typeof(*raw_inode), extra_xtime) -
> > \
> > +	    offsetof(typeof(*raw_inode), i_extra_isize) +
> > \
> > +   	    sizeof((raw_inode)->extra_xtime) <=
> > \
> > +	    le16_to_cpu((raw_inode)->i_extra_isize)) {
> > \
> > +		if (sizeof((inode)->xtime.tv_sec) > 4)                        \
> > +			(inode)->xtime.tv_sec |=                              \
> > +			(__u64)(le32_to_cpu((raw_inode)->extra_xtime) &       \
> > +				EXT3_EPOCH_MASK) << 32;                       \
> > +			(inode)->xtime.tv_nsec =                              \
> > +				(le32_to_cpu((raw_inode)->extra_xtime) &      \
> > +				EXT3_NSEC_MASK) >> 2;                         \
> > +	}
> > \
> > +} while (0)
> 
> ow, my eyes.  Can we find a way to do this in C rather than in cpp?

The macro is working on the field names of the inode in most places
(e.g. i_mtime, i_ctime, etc) rather than the values.  You _could_ do it
in C, but it would mean moving all of the "offsetof()" into the caller
(basically putting the whole macro in-line at the caller) or doing math
on the pointer addresses at runtime instead of compile time.

It boils down to a check whether the particular nanosecond field is
inside the reserved space in the inode or not, so it ends up a comparison
against a constant.  For ctime:

	if (4 <= le32_to_cpu((raw_inode)->i_extra_isize) {

And the second "if" decides whether to save bits > 32 in the seconds
field for 64-bit architectures, so it is also evaluated at compile time.

Better to have this in a macro than in the code itself.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
