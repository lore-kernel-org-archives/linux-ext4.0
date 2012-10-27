From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 issue after unclean shutdown and reboot
Date: Fri, 26 Oct 2012 20:07:36 -0400
Message-ID: <20121027000736.GA31030@thunk.org>
References: <508B199E.6020107@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Martin <marogge@onlinehome.de>, linux-ext4@vger.kernel.org,
	Nix <nix@esperi.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57894 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966897Ab2J0AHo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Oct 2012 20:07:44 -0400
Content-Disposition: inline
In-Reply-To: <508B199E.6020107@onlinehome.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've bcc'ed stable@vger.kernel.org, LKML, and greg-kh, since I suspect
they aren't interested in all of these details... we'll keep this on
linux-ext4 for sanity's sake.

On Sat, Oct 27, 2012 at 01:15:42AM +0200, Martin wrote:
> 
> sorry for the repetition, but Theodore Ts'o asked me to re-post this
> as a new mail thread in order to keep track of this more easily.

1)  Is it repeatable?  This is what happened once.  Can you reliably reproduce it?

2)  Can you send the full dmesg of the previous boot and the boot where
you found the problem?

3)  Can you send me the fsck logs?

4)  Can you send me the output dumpe2fs on the file system in question?

Thanks....

						- Ted
