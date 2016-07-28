From: Dave Chinner <david@fromorbit.com>
Subject: Re: 4.7.0-rc7 ext4 error in dx_probe
Date: Thu, 28 Jul 2016 10:00:57 +1000
Message-ID: <20160728000057.GW16044@dastard>
References: <20160718105707.GA4253@sig21.net>
 <20160718133843.GA26664@thunk.org>
 <alpine.DEB.2.20.12.1607252154570.8973@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Johannes Stezenbach <js@sig21.net>,
	linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:13468 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758277AbcG1ABT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jul 2016 20:01:19 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.12.1607252154570.8973@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 25, 2016 at 09:55:06PM -0700, Christian Kujau wrote:
> On Mon, 18 Jul 2016, Theodore Ts'o wrote:
> > system corruption detected earlier.  The problem is people
> > unfortunately run with their file systems set to errors=continue,
> 
> The first thing I do after creating an ext4 fs is to set this to 
> errors=remount-ro :-)
> 
> Isn't "remount-ro" was XFS is doing when it detects an error?

No, XFS shuts down and prevents all further access to the filesystem
when it hits a corruption that it can't continue onwards from. This
is not optional in XFS - to continue after such a corruption is
detected will only make the corruption worse....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
