From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Wed, 21 May 2008 20:36:33 +0100
Message-ID: <20080521193633.GA26780@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org> <200805191316.27551.chris.mason@oracle.com> <200805191439.36577.chris.mason@oracle.com> <20080521112224.GD5028@ucw.cz> <20080521110324.668048e0.akpm@linux-foundation.org> <20080521182949.GL8581@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Machek <pavel@suse.cz>,
	Chris Mason <chris.mason@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Andi
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:50178 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759063AbYEUTiS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2008 15:38:18 -0400
Content-Disposition: inline
In-Reply-To: <20080521182949.GL8581@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, May 21, 2008 at 11:03:24AM -0700, Andrew Morton wrote:
> > 
> > afaik there is no need to enable this feature if the machine (actually
> > the disks) are on a UPS, yes?
> 
> Yes, as long as you're confident that there won't be a kernel
> bug/regression causing a lockup while the server is under severe
> memory pressure while doing lots of fsync's, file creations, renames,
> etc.  And as long as your 100% confident that UPS's will never fail,
> janitors will never accidentally hit the Emergency Power Office

Can a kernel lockup cause this kind of corruption?

Will a system reboot wipe the disk's write cache?

I had imagined only power loss would prevent the disk from
writing it's cache eventually; is that wrong?

-- Jamie

