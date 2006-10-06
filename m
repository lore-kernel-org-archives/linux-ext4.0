From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Thu, 5 Oct 2006 21:54:42 -0700
Message-ID: <20061005215442.310b7792.rdunlap@xenotime.net>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	<20061005205526.7fe744f5.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:63954 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751784AbWJFExP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 00:53:15 -0400
Received: from midway.site ([71.117.236.95]) by xenotime.net for <linux-ext4@vger.kernel.org>; Thu, 5 Oct 2006 21:53:14 -0700
To: Andrew Morton <akpm@osdl.org>
In-Reply-To: <20061005205526.7fe744f5.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 5 Oct 2006 20:55:26 -0700 Andrew Morton wrote:

> On Thu, 05 Oct 2006 13:23:30 -0500
> Dave Kleikamp <shaggy@austin.ibm.com> wrote:
> 
> > I have rebuilt the ext4/jbd2 patches against linux-2.6.19-rc1.  The
> > patch set is located at
> > ftp://kernel.org/pub/linux/kernel/people/shaggy/ext4/2.6.19-rc1/ext4-patches-2.6.19-rc1.tar.gz
> > 
> 
> So let me see if I have this right.
> 
> You grab Alexandre's kit from http://www.bullopensource.org/ext4/20060926/
> and a plain old `mke2fs -j' gives a filesystem which will mount as ext3 or
> ext4.
> 
> If you then mount this filesystem with `-t ext4dev -o extents', it becomes
> incompatible with the ext3 driver.  Yes?

I thought we s/ext4dev/ext4/ ??

> What else aren't we being told? ;)

---
~Randy
