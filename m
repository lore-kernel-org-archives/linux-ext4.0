From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Wed, 21 May 2008 11:49:17 -0700
Message-ID: <20080521114917.60bf42c7.akpm@linux-foundation.org>
References: <482DDA56.6000301@redhat.com>
	<20080518211140.b29bee30.akpm@linux-foundation.org>
	<200805191316.27551.chris.mason@oracle.com>
	<200805191439.36577.chris.mason@oracle.com>
	<20080521112224.GD5028@ucw.cz>
	<20080521110324.668048e0.akpm@linux-foundation.org>
	<20080521182949.GL8581@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933095AbYEUSuQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2008 14:50:16 -0400
In-Reply-To: <20080521182949.GL8581@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 21 May 2008 14:29:49 -0400 Theodore Tso <tytso@mit.edu> wrote:

> On Wed, May 21, 2008 at 11:03:24AM -0700, Andrew Morton wrote:
> > 
> > afaik there is no need to enable this feature if the machine (actually
> > the disks) are on a UPS, yes?
> 
> Yes, as long as you're confident that there won't be a kernel
> bug/regression causing a lockup while the server is under severe
> memory pressure while doing lots of fsync's, file creations, renames,
> etc.

That won't cause corruption, will it?  The problem is purely one of
"data which the disk acked didn't make it to platter"?

>  And as long as your 100% confident that UPS's will never fail,
> janitors will never accidentally hit the Emergency Power Office
> switch, and so on.

Well.  The product of two very small numbers is...
