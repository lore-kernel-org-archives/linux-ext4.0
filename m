From: Helge Deller <deller@gmx.de>
Subject: Re: [e2fsprogs PATCH] Userspace solution to time-based UUID without duplicates
Date: Sun, 16 Dec 2007 22:53:19 +0100
Message-ID: <200712162253.20928.deller@gmx.de>
References: <200711182038.22055.deller@gmx.de> <20071120230012.GF26022@thunk.org> <20071210053604.GF17037@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39275 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759702AbXLPVxc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Dec 2007 16:53:32 -0500
In-Reply-To: <20071210053604.GF17037@thunk.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday 10 December 2007, Theodore Tso wrote:
> On Tue, Nov 20, 2007 at 06:00:12PM -0500, Theodore Tso wrote:
> > Basically, the only way to solve this problem 100% in userspace would
> > be with a userspace daemon running as a privileged user, and some kind
> > of Unix domain socket.
> > 
> > Patches to implement this in the e2fsprogs UUID library would be
> > greatfully accepted.
> 
> This patch creates a userspace uuidd which correctly generates
> time-based (version 1) UUID's, with the clock sequence number stored
> in the filesystem so we correctly detect time going backwards across
> processes and even across reboots.
> 
> I believe this patch is a better solution than Helge's kernel patch
> solution or the kludgy patch to e2fsprogs in the the SLES RPM which
> tries to solve this problem in another way, but which has been
> problematic in the past.
> 
> Helge, could you try this out and see if it meets your needs?
> 
> (Ted's patch to e2fsprogs removed here)

FYI, we are currently discussing and testing this proposed patch to e2fsprogs off-list in Red Hat's bugzilla:
https://bugzilla.redhat.com/show_bug.cgi?id=233471

Helge
