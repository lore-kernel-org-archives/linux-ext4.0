From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fw: Re: 2.6.21-rc3-mm1
Date: Tue, 13 Mar 2007 10:05:45 -0500
Message-ID: <45F6BDC9.8080205@redhat.com>
References: <20070312220426.2b1d7aaa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Radoslaw Szkodzinski <astralstorm@gmail.com>,
	Kalpak Shah <kalpak@clusterfs.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030581AbXCMPGq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Mar 2007 11:06:46 -0400
In-Reply-To: <20070312220426.2b1d7aaa.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:

> And broken stuff too :-)
> The nanoseconds patch is broken on x86_64 - makes mtimes from the future:
> e.g. year 2431. I suspect an endianness issue.
> x86 works fine according to my sources.
>
> The files themselves have correct mtimes, as booting previous kernel
> or one w/o the nanoseconds patch works fine.
There were later patches posted to the list after this version, I think, which
are not yet in Ted's tree... I'll find some time today to test the "take3" version
on x86_64, unless someone beats me to it.

-Eric
