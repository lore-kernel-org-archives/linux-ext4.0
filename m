From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2 0/2] ext4: Add pollable sysfs entry for block threshold
 events
Date: Wed, 18 Mar 2015 11:12:24 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1503181059150.23465@localhost.localdomain>
References: <1426512329-24299-1-git-send-email-b.michalska@samsung.com> <20150316132843.GA8188@infradead.org> <550945D5.4060805@samsung.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Christoph Hellwig <hch@infradead.org>, adilger.kernel@dilger.ca,
	tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
To: Beata Michalska <b.michalska@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbbCRKM4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2015 06:12:56 -0400
In-Reply-To: <550945D5.4060805@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 18 Mar 2015, Beata Michalska wrote:

> Date: Wed, 18 Mar 2015 10:31:01 +0100
> From: Beata Michalska <b.michalska@samsung.com>
> To: Christoph Hellwig <hch@infradead.org>
> Cc: lczerner@redhat.com, adilger.kernel@dilger.ca, tytso@mit.edu,
>     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
>     kyungmin.park@samsung.com
> Subject: Re: [PATCH v2 0/2] ext4: Add pollable sysfs entry for block threshold
>      events
> 
> On 03/16/2015 02:28 PM, Christoph Hellwig wrote:
> > Between this and the recent tmpfs discussion I really think this
> > needs to be done in a generic way.  Given that the quota noticiations
> > already use netlink general space notifications seem like a very
> > sensible extension for them.
> > 
> 
> First of all, apologies for late response.
> 
> I do agree that having a generic solution is the perfect one
> though non-trivial. If I understood You correctly, You would
> like to have quota being extended to cover the case in subject;
> smth similar to xfs project quota and its pqnoenforce mount
> option, as this would require disabling enforcing both:
> soft and hard limits ?

As Jan already mentioned the problem with quota is that it really
is accounting for used space per user, which is not really ideal for
this scenario. I have not seen the tmpfs discussions so maybe
they have a solution ?

Also, implementing noenforce should should be relatively easy.

> 
> 
> We could also consider going back to already mentioned,
> in another thread, the netlink notification interface proposal,
> though this still leaves the problem on how to setup the thresholds
> (as it covers only the ENOSPC case).

As Ted mentioned in one of his replies, filesystem would have to
support it at some level. Probably setting a value within a
superblock and then check against this value.

The netlink notification interface would then serve only as a mean
to notify the user.

Thanks!
-Lukas

> 
> 
> BR
> Beata
> 
> 
