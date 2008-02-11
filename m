From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH][0/28] Lustre e2fsprogs patch series
Date: Sun, 10 Feb 2008 23:19:12 -0500
Message-ID: <20080211041912.GC26205@mit.edu>
References: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60391 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbYBKETP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Feb 2008 23:19:15 -0500
Content-Disposition: inline
In-Reply-To: <20080202075943.GB23836@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 02, 2008 at 12:59:43AM -0700, Andreas Dilger wrote:
> The following series of emails will contain the large part of the
> e2fsprogs patch series that is used for Lustre.  It will not contain
> the regression tests for EXTENTS nor the DIR_NLINK features, as those
> are very large and were previously submitted.
> 
> A full tarball that includes the patches, series, and regression tests
> will be uploaded to ftp://ftp.lustre.org/pub/lustre/other/e2fsprogs/

Hey Andreas,

I've applied these patches to the tip of "maint", and exported it as
"e2fsprogs-interim" on the e2fsprogs git repository.  There quite a
few patch conflicts, mostly due to some changes that had happened on
the tip of maint, but also apparently because your patchset was
missing the flex bg changes.  I haven't applied them yet, but I'll
probably tack them at the end.

If you could sanity check to make sure they are sane, I would
appreciate it.

						- Ted
