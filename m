From: Andrew Morton <akpm@osdl.org>
Subject: Re: + ext4-enable.patch added to -mm tree
Date: Thu, 5 Oct 2006 22:07:48 -0700
Message-ID: <20061005220748.2d124f57.akpm@osdl.org>
References: <200610060036.k960aB76011550@shell0.pdx.osdl.net>
	<20061005215941.f0681c66.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com, shaggy@austin.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:23206 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932579AbWJFFHw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 01:07:52 -0400
To: Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <20061005215941.f0681c66.rdunlap@xenotime.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 5 Oct 2006 21:59:41 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> > +config EXT4DEV_FS
> > +	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
> > +	depends on EXPERIMENTAL
> > +        select JBD
> > +        help
> 
> ugh, I'm getting seasick from looking at that indentation.
> I don't have an ext4 patchset ATM, but I'll fix that if no one
> else does.

That's someone's broken tab key again.  I fixed up my copy of that patch.
