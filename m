From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Eric Whitney's ext4 scaling data
Date: Tue, 26 Mar 2013 23:35:54 -0400
Message-ID: <20130327033554.GE5861@thunk.org>
References: <nsxhajyzu6n.fsf@closure.thunk.org>
 <20130327033322.GB9887@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56191 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258Ab3C0Df5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Mar 2013 23:35:57 -0400
Content-Disposition: inline
In-Reply-To: <20130327033322.GB9887@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 11:33:23AM +0800, Zheng Liu wrote:
> 
> Thanks for sharing this with us.  I have an rough idea that we can create
> a project, which have some test cases to test the performance of file
> system.....

There is bitrotted benchmarking support into xfstests.  I know some of
the folks at SGI have wished that it could be nursed back to health,
but having not looked at it, it's not clear to me whether it's better
to try to add benchmarking capabilities into xfstests, or as a
separate project.

The real challenge with doing this is that it tends to be very system
specific; if you change the amount of memory, number of CPU's, type of
storage, etc., you'll get very different results.  So any kind of
system which is trying to detect performance regression really needs
to be run on a specific system, and what's important is the delta from
previous kernel versions.

The other thing I'll note is that Eric's results were especially
interesting because he had (in the past) access to a system with a
combination of a fast storage (via a large RAID array), and a large
number of CPU cores, which is useful for testing scalability.

These days, a fast PCIe attached storage can someone replace a large
RAID array, but most of us don't necessarily have access to a very
large (4 or more CPU sockets) system.

						- Ted
