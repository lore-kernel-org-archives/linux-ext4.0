From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Kernel Errors: Wrong Opcodes
Date: Mon, 12 Nov 2012 09:54:33 -0500
Message-ID: <20121112145433.GE4895@thunk.org>
References: <87zk2mvsag.wl%oehme.markus@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Markus Oehme <oehme.markus@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60660 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab2KLOyh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Nov 2012 09:54:37 -0500
Content-Disposition: inline
In-Reply-To: <87zk2mvsag.wl%oehme.markus@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 12, 2012 at 02:56:23PM +0100, Markus Oehme wrote:
> Hello,
> 
> I see lots of the following errors on my amd64 machine under heavy load
> (specifically the gcc test suite). Since the trace mentions ext4 I decided
> to send this to the ext4 mailing list.
> 
> The scenario: I'm running a Hardened Gentoo ~amd64 (Intel Core2 Quad) box
> with gcc-4.7.2 and Linux 3.6.6 with hardening patches (grsec). During a
> build from source of gcc-4.7.2 the error prints to the console, specifically
> this seems to occur during the test phase. There are multiple instances of
> the error all with the same call trace. The computer stays usable, but the
> build directory of the gcc build is somehow damaged. It is afterwards
> impossible to delete the build directory (rm simply hangs forever) until I
> reboot the machine. After the reboot everything seems to be fine again.

Invalid opcode sure sounds like it's a compiler issue.  Since you can
relatively easily reproduce this, can you try recompiling a kernel w/o
hardening, and see if the problem goes away?  If it does, you can send
a bug report to the GCC folks.

Regards,

						- Ted
