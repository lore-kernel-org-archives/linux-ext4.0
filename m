From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V3] xfstests: make 275 pass
Date: Sat, 8 Sep 2012 10:09:54 +1000
Message-ID: <20120908000954.GW15292@dastard>
References: <4F04A6E6.1090304@redhat.com>
 <4F04BC81.1000207@redhat.com>
 <20120104231725.GB24466@dastard>
 <4F207079.6050401@sandeen.net>
 <504A5176.5020302@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Eryu Guan <eguan@redhat.com>, xfs-oss <xfs@oss.sgi.com>,
	Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:38404 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628Ab2IHAJ6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Sep 2012 20:09:58 -0400
Content-Disposition: inline
In-Reply-To: <504A5176.5020302@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 07, 2012 at 02:56:38PM -0500, Eric Sandeen wrote:
> On 1/25/12 3:13 PM, Eric Sandeen wrote:
> > Ok, this is a significant rework of 275, which made too many
> > assumptions about details of space usage and failed on several
> > filesystems (it passed on xfs, but only by accident).
> > 
> > This new version tries to leave about 256k free, then tries
> > a single 1M IO, and fails only if 0 bytes are written.
> > 
> > It also sends a lot more to $seq.full for debugging on failure
> > and fixes a few other stylistic things.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> 
> Poor Zach ran into this one again.  Can I get a review of this
> version, and I'll merge it if it looks good?

Looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
