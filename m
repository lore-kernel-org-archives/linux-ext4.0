From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] [PATCH 1/1] nanosecond timestamps
Date: Wed, 7 Feb 2007 10:58:01 -0700
Message-ID: <20070207175800.GA6565@schatzie.adilger.int>
References: <1170427180.6086.17.camel@garfield> <20070206040916.GF11018@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>, sct@redhat.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:53776 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161413AbXBGR6E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Feb 2007 12:58:04 -0500
Content-Disposition: inline
In-Reply-To: <20070206040916.GF11018@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Feb 05, 2007  23:09 -0500, Theodore Tso wrote:
> On Fri, Feb 02, 2007 at 08:09:40PM +0530, Kalpak Shah wrote:
> > This patch is a spinoff of the old nanosecond patches. It includes some
> > cleanups and addition of a creation timestamp. The
> > EXT3_FEATURE_RO_COMPAT_EXTRA_ISIZE flag has also been added along with
> > s_{min, want}_extra_isize fields in struct ext3_super_block. 
> 
> Thanks for sending it.  I haven't had a chance to go over it in detail
> yet, but one quick comment; the patch looks like it got line-wrapped
> by your mail agent (looks like you're using Evolution 2.0).  Could you
> send it as a text/plain attachment, or otherwise fix your mailer to
> not wrap your patches?  
> 
> It might be nice if the patch had a way of adjusting the granularity
> by masking off bits of the nanoseconds field, so we can benchmark how
> much overhead constantly updating the ctime field is going to cost us.  

Can anyone suggest a benchmark which will test this area?  Bull had done
some testing with the inode version patch (it also forces an update for
every change to an inode) and reported no noticable performance loss.
That could have been because of CPU headroom available to do repeat copies
of the in-core inode to the on-disk inode, which may hurt in a more CPU
constrained environment (other server code, multiple filesystems, etc).

Before we go to changing the patch, we may as well start by just testing
before vs. after patch (still using large inodes, for consistency).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
