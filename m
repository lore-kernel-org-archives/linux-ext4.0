From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH] ext3: remove inode constructor
Date: Sat, 5 May 2007 02:02:02 -0700
Message-ID: <20070505020202.8edd0110.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0705041311230.1455@sbz-30.cs.Helsinki.FI>
	<20070504130241.c436eb43.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705051156200.20079@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sct@redhat.com, adilger@clusterfs.com, clameter@sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423169AbXEEJCp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 May 2007 05:02:45 -0400
In-Reply-To: <Pine.LNX.4.64.0705051156200.20079@sbz-30.cs.Helsinki.FI>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 5 May 2007 11:58:45 +0300 (EEST) Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> On Fri, 4 May 2007, Andrew Morton wrote:
> > I got 100% rejects against this because Christoph has already had
> > his paws all over the slab constructor code everywhere.
> > 
> > Was going to fix it up but then decided that we ought to make changes
> > like this to ext4 as well.  Ideally beforehand, but simultaneously is
> > OK as long as it's simple enough.
> 
> I'll send you proper patches for them (and will convert other filesystems 
> too).

May as well.

> On Fri, 4 May 2007, Andrew Morton wrote:
> > btw, for a benchmark I'd suggest just a silly create-10000-files
> > tight loop rather than something more complex like postmark.
> 
> Do you want me to redo the benchmarks or are you happy enough with the 
> postmark numbers?

I doubt if this is measurable, really.  It'll be something like the
difference between an L1 hit and an L2 hit in amongst all the other stuff
we do on a per-inode basis.
