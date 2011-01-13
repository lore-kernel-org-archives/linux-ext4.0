From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Re: [linux-pm] Oops while going into hibernate
Date: Thu, 13 Jan 2011 12:49:53 +0100 (CET)
Message-ID: <alpine.LFD.2.02.1101131248510.1899@localhost6.localdomain6>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6> <20110112162655.GA13496@thunk.org> <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6> <20110112172646.GB13496@thunk.org> <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6>
 <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu> <1294917140.2781.5.camel@shrek.rexursive.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>,
	pm list <linux-pm@lists.linux-foundation.org>,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	LKML Kernel <linux-kernel@vger.kernel.org>
To: Bojan Smojver <bojan@rexursive.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:59730 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab1AMLt5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jan 2011 06:49:57 -0500
In-Reply-To: <1294917140.2781.5.camel@shrek.rexursive.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Thu, 13 Jan 2011, Bojan Smojver wrote:
> On Wed, 2011-01-12 at 19:44 -0500, Theodore Tso wrote:
> > It looks like somehow the pages were left marked as dirty, so the
> > writeback daemons attempted writing back a page to an inode which was
> > never opened read/write (and in fact as a text page
> > for /usr/bin/killall, was mapped read/only).
> 
> Just out of curiosity, when this happens, is LZO compression being used
> with hibernation (default in 2.6.37) or has it been disabled?
LZO is being used - should I try with hibernate=nocompress?

Regards,
Sebastian
