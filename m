From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -V3 01/11] percpu_counters: make fbc->count read atomic
 on 32 bit architecture
Date: Wed, 27 Aug 2008 21:06:52 -0700
Message-ID: <20080827210652.dcbe5ff4.akpm@linux-foundation.org>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20080827120553.9c9d6690.akpm@linux-foundation.org>
	<20080828034816.GA6440@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, a.p.zijlstra@chello.nl,
	linux-kernel@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850AbYH1EHx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Aug 2008 00:07:53 -0400
In-Reply-To: <20080828034816.GA6440@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 28 Aug 2008 09:18:16 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> > This is now too large to be inlined.
> > 
> 
> 
> How do we actually figure that out ? I have been making that mistakes
> quiet often.

Well.  Experience and guesswork, mainly.

But a useful metric is to look and the /bin/size output before and
after the inlining.  In this case fs/ext3/ialloc.o's text shrunk 40-odd
bytes, which we think is a net benefit due to reduced CPU cache
pressure.


