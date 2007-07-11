From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATHC] Fix for ext2 reservation (Re: -mm merge plans for
	2.6.23)
Date: Tue, 10 Jul 2007 17:04:17 -0700
Message-ID: <1184112257.8390.8.camel@dyn9047017100.beaverton.ibm.com>
References: <20070710113704.8b20f3c3.akpm@linux-foundation.org>
	 <4693E07E.4010300@mbligh.org>
	 <1184105757.8390.6.camel@dyn9047017100.beaverton.ibm.com>
	 <20070710165507.f8e61bb2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Martin Bligh <mbligh@mbligh.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Greg KH <greg@kroah.com>, Hugh Dickins <hugh@veritas.com>,
	Jeremy Orlow <jorlow@google.com>,
	Nick Piggin <piggin@cyberone.com.au>,
	Mingming Cao <cmm@us.ibm.com>,
	ext4 <linux-ext4@vger.kernel.org>, stable@kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:51606 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764635AbXGKACg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jul 2007 20:02:36 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6B02afr009442
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 20:02:36 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6B02aMt216364
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 18:02:36 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6B02Yv3011734
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 18:02:36 -0600
In-Reply-To: <20070710165507.f8e61bb2.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-07-10 at 16:55 -0700, Andrew Morton wrote:
> On Tue, 10 Jul 2007 15:15:57 -0700
> Badari Pulavarty <pbadari@us.ibm.com> wrote:
> 
> > Well, I looked at the problem now and here is the fix :)
> 
> whee, thanks.
> 
> > Greg, Please consider this for stable release also.
> 
> No, it is only relevant to -mm's ext2-reservations.patch.

Yes. Sorry. I was looking at -mm tree and assumed that
ext2-reservation code made into mainline also :(

Greg, please ignore the patch for stable.

Thanks,
Badari
