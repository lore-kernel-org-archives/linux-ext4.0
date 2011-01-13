From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Re: [linux-pm] Oops while going into hibernate
Date: Thu, 13 Jan 2011 13:31:02 +0100 (CET)
Message-ID: <alpine.LFD.2.02.1101131329070.1899@localhost6.localdomain6>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6> <20110112162655.GA13496@thunk.org> <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6> <20110112172646.GB13496@thunk.org> <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6>
 <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu> <alpine.LFD.2.02.1101131238480.1899@localhost6.localdomain6> <6009472527.979427505@rexursive.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-pm@lists.linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Bojan Smojver <bojan@rexursive.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:55365 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab1AMMbH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jan 2011 07:31:07 -0500
In-Reply-To: <6009472527.979427505@rexursive.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Thu, 13 Jan 2011, Bojan Smojver wrote:
> > Yes. I basically did a
> > echo reboot > /sys/power/disk
> > for i in {1..5} ;do echo disk > /sys/power/state ;done
> > and it crashed very early in the second suspend.
> 
> Was compression on or off?
compression was on. I did a re-test with hibernate=nocompress
..but with the same result

Regards,
Sebastian
