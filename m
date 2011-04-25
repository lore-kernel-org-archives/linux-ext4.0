From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4_put_super is not called during system shutdown or restart
Date: Mon, 25 Apr 2011 14:23:09 -0400
Message-ID: <20110425182309.GA9486@thunk.org>
References: <BEC5ADCE-0B2E-4CE2-8654-9D2F7B787684@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Zhao Cai <zhaocai@me.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57309 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab1DYSXO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Apr 2011 14:23:14 -0400
Content-Disposition: inline
In-Reply-To: <BEC5ADCE-0B2E-4CE2-8654-9D2F7B787684@me.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 25, 2011 at 12:12:02AM -0400, Zhao Cai wrote:
> I would appreciate if anyone can give me an answer. Is it designed
> to be like this?
> 
> Detailed situation: The system is ubuntu 11.04 installed in
> VMware. I notice that ext4_put_super() is called when I unmount a
> non-root ext4 partition. But it is not when I restart or shutdown
> the system.
> 

What happens on most Linux systems is that root file system gets
remounted read/only during the reboot/shutdown sequence, whil non-root
file systems are unmounted.  I haven't tried 11.04 so I can't tell you
what it is doing.  If it isn't umounting the non-root file systems, or
at least remounting the non-root file systems read/only, then
something is probably going wrong.  That's a question for the
distribution....

						- Ted
