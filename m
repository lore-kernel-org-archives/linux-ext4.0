From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Fri, 2 Mar 2007 09:01:05 -0800
Message-ID: <20070302090105.43f9b41c.akpm@linux-foundation.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<45E7BE4B.5070602@us.ibm.com>
	<45E83FCE.4040008@redhat.com>
	<1172851980.9213.13.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34829 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992626AbXCBRF1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2007 12:05:27 -0500
In-Reply-To: <1172851980.9213.13.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 02 Mar 2007 08:13:00 -0800 Badari Pulavarty <pbadari@us.ibm.com> wrote:

> > 
> > > What about 
> > > if the
> > > blocks already exists ? What would be return values in those cases ?
> > 
> > 0 on success, other normal errors oetherwise..
> > 
> > If asked for a range that includes already-allocated blocks, you just 
> > allocate any non-allocated blocks in the range, I think.
> 
> Yes. What I was trying to figure out is, if there is a requirement that
> interface need to return exact number of bytes it *really* allocated
> (like write() or read()). I can't think of any, but just wanted to
> through it out..

Hopefully not, because posix didn't anticipate that.

We could of course return a positive number on success, but it'd get
tricky on 32-bit machines.

> BTW, what is the interface for finding out what is the size of the
> pre-allocated file ? 

stat.st_blocks?
