From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] ext4: Adjust mineln with discard_granularity in
 FITRIM code
Date: Wed, 23 Feb 2011 19:19:18 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102231917520.2934@dhcp-27-109.brq.redhat.com>
References: <1297789585-5986-1-git-send-email-lczerner@redhat.com> <1297789585-5986-2-git-send-email-lczerner@redhat.com> <20110223175835.GO2924@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab1BWSTX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Feb 2011 13:19:23 -0500
In-Reply-To: <20110223175835.GO2924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 23 Feb 2011, Ted Ts'o wrote:

> On Tue, Feb 15, 2011 at 06:06:25PM +0100, Lukas Czerner wrote:
> > Discard granularity tells us the minimum size of extent to be discarded.
> > Use that information to adjust minlen properly in FITRIM code. Smaller
> > extents will be ignored anyway, so we can optimize by not even trying to
> > discard them.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Applied to the ext4 patch queue, with a rewritten commit description.
> 
> "Always write with a deep sympathy for the reader"
> 
> 	      	     	  	       - Ted
> 
> ext4: Adjust minlen with discard_granularity in the FITRIM ioctl
> 
> From: Lukas Czerner <lczerner@redhat.com>
> 
> Discard granularity tells us the minimum size of extent that can be
> discard by the device.  If the user supplies a minimum extent that
> should be discarded (range.minlen) which is smaller than the discard
> granularity, increase minlen to the discard granularity, since there's
> no point submitting trim requests that the device will reject anyway.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 

Hi Ted,

thanks for merging and for the description. My English still needs a lot
of practice :)

Thanks!
-Lukas
