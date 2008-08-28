From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH -V3 01/11] percpu_counters: make fbc->count read atomic on 32 bit architecture
Date: Fri, 29 Aug 2008 00:19:32 +1000
Message-ID: <200808290019.32744.nickpiggin@yahoo.com.au>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080828034816.GA6440@skywalker> <20080827210652.dcbe5ff4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, a.p.zijlstra@chello.nl,
	linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:41320 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750836AbYH1ETk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Aug 2008 00:19:40 -0400
In-Reply-To: <20080827210652.dcbe5ff4.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday 28 August 2008 14:06, Andrew Morton wrote:
> On Thu, 28 Aug 2008 09:18:16 +0530 "Aneesh Kumar K.V" 
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> > > This is now too large to be inlined.
> >
> > How do we actually figure that out ? I have been making that mistakes
> > quiet often.
>
> Well.  Experience and guesswork, mainly.
>
> But a useful metric is to look and the /bin/size output before and
> after the inlining.  In this case fs/ext3/ialloc.o's text shrunk 40-odd
> bytes, which we think is a net benefit due to reduced CPU cache
> pressure.

Weighed against register save/restore, compiler barrier, and function
call cost of uninlined. These can add up to 10s of cycles per call I've
seen, so if it is called several times between each icache miss it can
easily be worth inlining. Basically, measurement is required, and if it
isn't important enough to measure policy tends to default to uninline if
that saves space.
