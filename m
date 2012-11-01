From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: ext4: fix metadata checksum calculation for the superblock
Date: Wed, 31 Oct 2012 18:13:12 -0700
Message-ID: <20121101011312.GG19591@blackbox.djwong.org>
References: <20121008024126.GC468@thunk.org>
 <20121101010521.893.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, tm@tao.ma
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17837 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab2KABNT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Oct 2012 21:13:19 -0400
Content-Disposition: inline
In-Reply-To: <20121101010521.893.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2012 at 09:05:21PM -0400, George Spelvin wrote:
> I'm currently running with two ext4 patches:
> 
> Author: Theodore Ts'o <tytso@mit.edu>
> Date: Sun Oct 7 22:18:56 2012 -0400
> Subject: ext4: fix metadata checksum calculation for the superblock
> 
> Author: Darrick J. Wong <darrick.wong@oracle.com>
> Date: Wed Oct 17 12:51:30 2012 -0700
> Subject: ext4: Don't verify checksums of dx non-leaf nodes during fallback linear scan
> 
> They appear to fix real problems.  I notice, that neither of these have
> made it into 2.6.5.  Should they be sent to -stable at some point?
> 
> I'm not trying to overrule your judgements on the matter, just ensure that
> the omission is actually a conscious decision rather than an oversight.

<shrug> I was wondering too, but I figured Ted was probably busy dealing with
the corruption bug and such.

(Which itself doesn't seem to be in 3.6.x yet)

I suppose it's a good sign that it's been more than a week and you haven't hit
anything else...

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
