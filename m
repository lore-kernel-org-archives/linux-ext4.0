From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix free clusters calculation in bigalloc
 filesystem
Date: Fri, 22 Feb 2013 08:57:47 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1302220852210.14141@localhost>
References: <1361433665-16880-1-git-send-email-lczerner@redhat.com> <20130222051048.GC13667@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563Ab3BVH5w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2013 02:57:52 -0500
In-Reply-To: <20130222051048.GC13667@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 22 Feb 2013, Theodore Ts'o wrote:

> Date: Fri, 22 Feb 2013 00:10:48 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] ext4: fix free clusters calculation in bigalloc
>     filesystem
> 
> On Thu, Feb 21, 2013 at 09:01:05AM +0100, Lukas Czerner wrote:
> > 
> > Moreover when calculating number of root clusters we should be using
> > macro EXT4_NUM_B2C() instead of EXT4_C2B() otherwise the result will
> > usually be off by one.
> 
> That should be "instead of EXT4_B2C()", and I don't think this is
> true, since the number of blocks should always be a multiple of the
> cluster ratio.  So the use of EXT4_B2C() is a bit of an optimization
> (it avoids an add and mask operation), but it's probably not a
> measurable optimizatoin in practice.
> 
> 							- Ted

Oh right it was EXT4_B2C(), I'll update the description. Even though
it should always be a multiple of cluster ratio it's really bad
precedence for the use of EXT4_B2C() since it is confusing enough
as it is with blocks/clusters.

I'll resend.

-Lukas
