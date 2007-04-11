From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: debugfs fill_bgs command?
Date: Wed, 11 Apr 2007 16:52:37 -0600
Message-ID: <20070411225237.GH5967@schatzie.adilger.int>
References: <461D4256.6020509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:34570 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161304AbXDKWwj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Apr 2007 18:52:39 -0400
Content-Disposition: inline
In-Reply-To: <461D4256.6020509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 11, 2007  15:17 -0500, Eric Sandeen wrote:
> I was wondering if others think it would be useful to have a "fill_bgs"
> command in debugfs; this would (minimally) mark the lower X bgs as full
> for both inodes & blocks (possibly either/or), to allow testing the
> higher block groups.  I'm using a hacked up version of this to do a
> little ext3 testing above 8T.  Given that this would really only be a
> testing option in nature, would it be accepted into e2fsprogs?  I'd
> probably need some sort of "unfill" command as well, to put the bg
> counters back where they should be; probably by actually reading the
> bitmaps.  This way fsck would still find a consistent filesystem...
> 
> I had originally written a set_bg_field function too, to go with inode &
> sb variants, though for marking the first few thousand bg's it was going
> to get a bit tedious... :)

Try "mke2fs -O lazy_bg XXX" and be happy.  Can be used on any kernel as
it is a COMPAT feature and marks all but first and last groups as full.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
