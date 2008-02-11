From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][0/28] Lustre e2fsprogs patch series
Date: Mon, 11 Feb 2008 13:09:28 -0700
Message-ID: <20080211200928.GG3029@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
 <20080211041912.GC26205@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53332 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623AbYBKUJb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Feb 2008 15:09:31 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1BK9Ule025350
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2008 12:09:31 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JW300501BUQZM00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 11 Feb 2008 12:09:30 -0800 (PST)
In-reply-to: <20080211041912.GC26205@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 10, 2008  23:19 -0500, Theodore Ts'o wrote:
> On Sat, Feb 02, 2008 at 12:59:43AM -0700, Andreas Dilger wrote:
> > The following series of emails will contain the large part of the
> > e2fsprogs patch series that is used for Lustre.  It will not contain
> > the regression tests for EXTENTS nor the DIR_NLINK features, as those
> > are very large and were previously submitted.
> 
> I've applied these patches to the tip of "maint", and exported it as
> "e2fsprogs-interim" on the e2fsprogs git repository.  There quite a
> few patch conflicts, mostly due to some changes that had happened on
> the tip of maint, but also apparently because your patchset was
> missing the flex bg changes.  I haven't applied them yet, but I'll
> probably tack them at the end.

The patch was based on e2fsprogs-1.40.5.  Also note that the majority
of patches are intended for upstream inclusion, with the exception of
the extents patches, which you are reworking.

> > A full tarball that includes the patches, series, and regression tests
> > will be uploaded to ftp://ftp.lustre.org/pub/lustre/other/e2fsprogs/

This didn't work out, as our FTP site was subsumed into a Sun-hosted
download site that week and I'm no longer able to make public-access
uploads.  I have to find some other location to host that tarball.

> If you could sanity check to make sure they are sane, I would
> appreciate it.

I need to catch up from travelling last week, hopefully I'll get to
it by the end of this week.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
