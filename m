From: Andrew Morton <akpm@osdl.org>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Thu, 5 Oct 2006 23:04:01 -0700
Message-ID: <20061005230401.0159e31b.akpm@osdl.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	<20061005205526.7fe744f5.akpm@osdl.org>
	<20061005215442.310b7792.rdunlap@xenotime.net>
	<20061006055305.GG22010@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:25009 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932603AbWJFGEH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 02:04:07 -0400
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20061006055305.GG22010@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 5 Oct 2006 23:53:05 -0600
Andreas Dilger <adilger@clusterfs.com> wrote:

> On Oct 05, 2006  21:54 -0700, Randy Dunlap wrote:
> > On Thu, 5 Oct 2006 20:55:26 -0700 Andrew Morton wrote:
> > > If you then mount this filesystem with `-t ext4dev -o extents', it becomes
> > > incompatible with the ext3 driver.  Yes?
> > 
> > I thought we s/ext4dev/ext4/ ??
> 
> No, we want to leave it at ext4dev for a while, to make it very clear
> that this is still under development.  We want to get the existing
> patches upstream so they don't become completely unwieldy, and earlier
> testing is also good, but it is not yet feature complete.
> 

What features are missing?

Heck, what features does it have now?  Guys, we cannot release this thing
to the public without telling them what it is, how to use it, where to get
the tools from and what the roadmap is.

