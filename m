From: Bill Nottingham <notting@redhat.com>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Fri, 20 Jun 2008 11:34:32 -0400
Message-ID: <20080620153432.GC25954@nostromo.devel.redhat.com>
References: <4859EFE2.2090202@linux.intel.com> <alpine.LFD.1.10.0806182242390.2907@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arjan van de Ven <arjan@linux.intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbYFTPgc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jun 2008 11:36:32 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806182242390.2907@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Linus Torvalds (torvalds@linux-foundation.org) said: 
> Or could this perhaps be an indication that it is specific to i686 some 
> way (eg a compiler issue?)

Yes. https://bugzilla.redhat.com/show_bug.cgi?id=451068

Bill
