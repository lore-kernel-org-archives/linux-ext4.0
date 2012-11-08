From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add hot tracking support.
Date: Thu, 8 Nov 2012 16:13:49 +1100
Message-ID: <20121108051349.GL6434@dastard>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
 <20121016000405.GA2864@dastard>
 <CAEH94LjKg78Fm=xROhHsrZkSMUFhJMWeec1b87e8jLh9cMzMGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:59387 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959Ab2KHFNy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Nov 2012 00:13:54 -0500
Content-Disposition: inline
In-Reply-To: <CAEH94LjKg78Fm=xROhHsrZkSMUFhJMWeec1b87e8jLh9cMzMGw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 07, 2012 at 04:38:23PM +0800, Zhi Yong Wu wrote:
> HI, Dave,
> 
> I guess that you should add some hot tracking stuff in some
> xfs_show_xxx function, right?

Yes, it should - I thought I did that. I recall seeing int
/proc/mounts, but maybe I was just hallucinating. I'll send an
updated version when I get to fixing it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
