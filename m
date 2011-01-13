From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Oops while going into hibernate
Date: Wed, 12 Jan 2011 19:44:17 -0500
Message-ID: <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6> <20110112162655.GA13496@thunk.org> <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6> <20110112172646.GB13496@thunk.org> <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	LKML Kernel <linux-kernel@vger.kernel.org>,
	pm list <linux-pm@lists.linux-foundation.org>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:65493 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756506Ab1AMAot convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jan 2011 19:44:49 -0500
In-Reply-To: <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jan 12, 2011, at 1:49 PM, Sebastian Ott wrote:

> 
> I did about 5 re-tests with different loads, the result was always:
> 
> [  249.238697] EXT4-fs (dasda1): inode #1106 has NULL jinode
> 
> # debugfs /dev/dasda1
> debugfs 1.41.10 (10-Feb-2009)
> debugfs:  ncheck 1106
> Inode   Pathname
> 1106    /usr/bin/killall
> debugfs:  q
> 

That looks really bogus.  /usr/bin/killall is a system binary, and there's no good reason that hibernation should be trying to write pages to that binary.

You said originally that the oops was happening "while going into hibernation right after resuming with...".   So that means you did a successful suspend/resume, and then the second suspend caused the oops?   It looks like somehow the pages were left marked as dirty, so the writeback daemons attempted writing back a page to an inode which was never opened read/write (and in fact as a text page for /usr/bin/killall, was mapped read/only).   Given that ext4 initializes jinode only when the file is opened read/write, the fact that it is null, and the fact that it makes no sense that a program would be modifying /usr/bin/killall as part of a suspend/resume, it looks very much like we just unmasked a software suspend bug....

-- Ted



