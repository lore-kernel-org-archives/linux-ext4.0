From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 unknown problem
Date: Mon, 30 Jul 2012 17:52:16 -0400
Message-ID: <20120730215216.GG10343@thunk.org>
References: <805800905.179241343676287217.JavaMail.root@shiva>
 <361097150.179261343676380170.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, info <info@plaintext.sk>
To: LuVar <luvar@plaintext.sk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42149 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab2G3VwV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 17:52:21 -0400
Content-Disposition: inline
In-Reply-To: <361097150.179261343676380170.JavaMail.root@shiva>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 30, 2012 at 08:26:20PM +0100, LuVar wrote:
> Hi,
> I have seriouse issue here. I have copyied about 7GB files to one of my ext4 partitions and from that point of time there is sustained write to that partition from jbd2/dm-3-8 process. I have lunched "sudo sync" command (about day ago :) and a few hours a after sync start, I have tryied to use umount on that partition... Booth of them are still running...
> 
> I have no serious data there, but if I could be helpfull in bugreport, give me some info what to do.

Try running the dmesg command, and see if there's anything interesting
there.  If you're not sure if it's interesting, send it to us and we
can take a quick look at it.

Regards,

					- Ted
