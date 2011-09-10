From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Bug 25832] kernel crashes when a mounted ext3/4 file system
 is physically removed
Date: Sat, 10 Sep 2011 10:06:28 -0400
Message-ID: <20110910140628.GA17511@thunk.org>
References: <20110909191354.GC3818@thunk.org>
 <Pine.LNX.4.44L0.1109091808030.22382-100000@netrider.rowland.org>
 <BAY151-W6176D929049AA9E2BDBAEBA1000@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stern@rowland.harvard.edu, bugzilla-daemon@bugzilla.kernel.org,
	linux-ext4@vger.kernel.org
To: Rocko Requin <rockorequin@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60000 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307Ab1IJOGc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Sep 2011 10:06:32 -0400
Content-Disposition: inline
In-Reply-To: <BAY151-W6176D929049AA9E2BDBAEBA1000@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 10, 2011 at 01:49:44AM +0000, Rocko Requin wrote:
> 
> The patch does stop my console-only test script from crashing the
> kernel (thanks for figuring this patch out, Ted!), but if I try it
> from a desktop, the desktop still freezes after two or three
> bind/unbind iterations. So I guess there must be another way to try
> and access the missing file system that also need patching.

Can you get stack traces or register information?  Via sysrq-t /
sysrq-p?  This might require setting up serial console on your desktop
if you don't have kernel mode switching set up so you can switch away
from the X server.

							- Ted
