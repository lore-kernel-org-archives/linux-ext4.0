From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -V3 01/11] percpu_counters: make fbc->count read atomic
	on 32 bit architecture
Date: Thu, 28 Aug 2008 09:57:37 +0200
Message-ID: <1219910257.6443.6.camel@twins>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20080827120553.9c9d6690.akpm@linux-foundation.org>
	 <1219870912.6395.45.camel@twins>
	 <20080827142250.7397a1a7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: aneesh.kumar@linux.vnet.ibm.com, cmm@us.ibm.com, tytso@mit.edu,
	sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:55180 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753565AbYH1H7Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 03:59:24 -0400
Received: from edge01.upc.biz ([192.168.13.236]) by viefep15-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080828075921.VELK18154.viefep15-int.chello.at@edge01.upc.biz>
          for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 09:59:21 +0200
In-Reply-To: <20080827142250.7397a1a7.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-08-27 at 14:22 -0700, Andrew Morton wrote:

> btw, what the heck is percpu_counter_init_irq()?  Some mysterious
> lockdep-specific thing?
> 
> <does git-fiddle.  Oh.  crappy changelog.>
> 
> I let that one leak through uncommented.  Must be getting old. 
> Probably it will need an EXPORT_SYMBOL() sometime.

Basically all it does it break the percpu_counter lock into two classes.

One for the irq-unsafe users and one for the irq-safe users. Without
this lockdep goes splat complaining about irq recursion deadlocks and
the like between these two separate users.

