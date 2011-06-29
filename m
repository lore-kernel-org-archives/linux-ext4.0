From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: Deprecate data=journal mount option
Date: Wed, 29 Jun 2011 13:49:27 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106291338270.6151@dhcp-27-109.brq.redhat.com>
References: <1309260363-19012-1-git-send-email-lczerner@redhat.com> <20110629044955.GA30312@untroubled.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Bruce Guenter <bruce@untroubled.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab1F2Ltb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Jun 2011 07:49:31 -0400
In-Reply-To: <20110629044955.GA30312@untroubled.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 28 Jun 2011, Bruce Guenter wrote:

> On Tue, Jun 28, 2011 at 01:26:03PM +0200, Lukas Czerner wrote:
> > Data journalling mode (data=journal) is known to be neglected by
> > developers and only minority of people is actually using it. This
> > mode is also less tested than the other two modes by the developers.
> > 
> > This creates a dangerous combination, because the option which seems
> > *safer* is actually less safe the others. So this commit adds a warning
> > message in case that data=journal mode is used, so the user is informed
> > that the mode might be removed in the future.
> 
> When I last benchmarked it, data=journal mode was considerably faster
> than the other modes for sync heavy work loads, such as mail servers.
> Have there been improvements to other (safe) modes that reverse this?
> 

No, not any specific change that I know of. The problem with
data=journal from performance perspective is that, it can improve fsync
heavy loads, however just for a limited bandwidth. Because as you
probably know in this mode it will write all data twice, however it will
generate fewer seeks. So yes, for sync heavy work load with small writes
(such as mail servers might do) the performance might be better. But it
is always the matter of benchmarking your particular case to decide if
it really helps, it is not like this is a general fact that
data=journal implies better performance for fsync heavy writes.

Also note that the even though bandwidth limit might go away (or scale
up significantly) for newer drives like SSD's, the same is true for
seeks, so I guess data=journal would not have any benefits on future
drives. Also as I said those code paths are not as well tested as the
other modes.

Thanks!
-Lukas

