From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
	features in larger inode
Date: Sun, 15 Jul 2007 22:13:20 +0200
Message-ID: <1184530400.5284.111.camel@lappy>
References: <1183275482.4010.133.camel@localhost.localdomain>
	 <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
	 <20070713020529.1486491f.akpm@linux-foundation.org>
	 <1184333621.20032.85.camel@twins>
	 <20070713121259.20066d5b.akpm@linux-foundation.org>
	 <20070713214746.GH23255@mami.zabbo.net> <1184504543.5284.96.camel@lappy>
	 <20070715111109.a2775ae4.akpm@linux-foundation.org>
	 <1184527263.5284.110.camel@lappy>
	 <20070715125921.87574a3a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Zach Brown <zach.brown@oracle.com>, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
	Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from canuck.infradead.org ([209.217.80.40]:33984 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbXGOUOP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Jul 2007 16:14:15 -0400
In-Reply-To: <20070715125921.87574a3a.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 2007-07-15 at 12:59 -0700, Andrew Morton wrote:
> On Sun, 15 Jul 2007 21:21:03 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Shows the current stacktrace where we violate the previously established
> > locking order.
> 
> yup, but the lock_page() which we did inside truncate_mutex was a 
> lock_page() against a different address_space: the blockdev mapping.
> 
> So this is OK - we'll never take truncate_mutex against the blockdev
> mapping (it doesn't have one, for a start ;))
> 
> This is similar to the quite common case where we take inode A's
> i_mutex inside inode B's i_mutex, which needs special lockdep annotations.
> 
> I think.  I haven't looked into this in detail.

Right, I can make lock_page classes per address space. Lets see if this
one goes away.
