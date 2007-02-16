From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: booked-page-flag.patch
Date: Fri, 16 Feb 2007 05:14:08 -0700
Message-ID: <20070216121408.GQ10715@schatzie.adilger.int>
References: <20070215004504.023a90f0.akpm@linux-foundation.org> <45D495EA.3060200@redhat.com> <m3k5yj49bw.fsf@bzzz.home.net> <20070215125654.b0f18ab3.akpm@linux-foundation.org> <m3fy973z9w.fsf@bzzz.home.net> <20070215152352.6ddcfa92.akpm@linux-foundation.org> <m3sld636g0.fsf@bzzz.home.net> <20070215234640.d52e5908.akpm@linux-foundation.org> <m3hctm3588.fsf@bzzz.home.net> <20070216000606.08372d6f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:43583 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbXBPMOK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Feb 2007 07:14:10 -0500
Content-Disposition: inline
In-Reply-To: <20070216000606.08372d6f.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Feb 16, 2007  00:06 -0800, Andrew Morton wrote:
> On Fri, 16 Feb 2007 10:56:55 +0300 Alex Tomas <alex@clusterfs.com> wrote:
> > well, even so we need to reserve not that block ony, but
> > also needed metadata (for the worst case).
> 
> Right.  Reserve all the blocks for the page and all the metadata for a page
> at that file offset.  Worst case.

This only really becomes an issue when the filesystem (+reservations)
is close to being full.  If we are close enough to worry about running
out of space we can also refuse to do delayed allocation.
 
Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
