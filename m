From: Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: one way to dmesg
Date: Wed, 04 Nov 2009 16:29:11 +0100
Message-ID: <1257348551.2091.1.camel@mini>
References: <1257344804.2852.11.camel@zwerg>
	 <87f94c370911040718k766d910fr23342c82d4632faa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49893 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756618AbZKDP3J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2009 10:29:09 -0500
In-Reply-To: <87f94c370911040718k766d910fr23342c82d4632faa@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Mittwoch, den 04.11.2009, 10:18 -0500 schrieb Greg Freemyer:
> On Wed, Nov 4, 2009 at 9:26 AM, Alexey Fisher
> <bug-track@fisher-privat.net> wrote:
> > Hallo,
> > this is sort of continue of discussion about unified way to mount fs
> > readonly.
> > I wont to know how about dmesg/printk. I see ext[234] produce different
> > logs on mount even it use same code. I feel like i have some time to
> > digg in. My target is easy to parse dmesg.
> 
> Patches for unified mount messages already exist.  Various versions
> have been posted in the last couple months.
> 
> I don't know if they have been accepted yet or not.

Can you point me this patch?
I found only "add a message in remount/umount for ext4"
http://patchwork.ozlabs.org/project/linux-ext4/list/?page=1


