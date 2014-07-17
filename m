From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Automatic fsck behavior
Date: Wed, 16 Jul 2014 22:14:25 -0500
Message-ID: <53C73F91.8040301@redhat.com>
References: <loom.20140717T043842-31@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Daniel <dnlfrm@immunepc.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbaGQDO0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jul 2014 23:14:26 -0400
In-Reply-To: <loom.20140717T043842-31@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/16/14, 9:55 PM, Daniel wrote:
> Hi,
> 
> Had some questions about automatic boot-time fsck, following a power-loss or
> hard-shutdown, etc.
> All prior research (web searching, etc) on this has been inconclusive.
> 
> 1) Does it do a real fsck or only a journal playback?

By default, e2fsck at boot time only replays the journal if
needed.

A full fsck at boot time is generally only done if:

*) The filesystem was marked with an error prior to the fsck due
   to a runtime metadata error
*) Mount-count or time-based thresholds have been reached
   (newer mke2fs doesn't set these threshold by default)

> 2) If it's a real fsck, is it done in repair mode or diagnostic mode?

Depends on how initscripts invoke it, but most likely
it is in preen ("repair the easy stuff") mode.

> Also, do the answers depend/vary according to ext4 version or anything else?

yep, see above, w.r.t. initscript behavior, older/newer mke2fs,
e2fsck.conf, mke2fs.conf, etc ;)

-Eric

 
> Thank you
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

