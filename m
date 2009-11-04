From: Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: one way to dmesg
Date: Wed, 04 Nov 2009 16:59:14 +0100
Message-ID: <1257350354.2091.9.camel@mini>
References: <1257344804.2852.11.camel@zwerg>
	 <87f94c370911040718k766d910fr23342c82d4632faa@mail.gmail.com>
	 <1257348551.2091.1.camel@mini>
	 <87f94c370911040746k49dce1f6ge8591f7714b8b19d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48112 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756914AbZKDP7M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2009 10:59:12 -0500
In-Reply-To: <87f94c370911040746k49dce1f6ge8591f7714b8b19d@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Mittwoch, den 04.11.2009, 10:46 -0500 schrieb Greg Freemyer:
> On Wed, Nov 4, 2009 at 10:29 AM, Alexey Fisher
> <bug-track@fisher-privat.net> wrote:
> > Am Mittwoch, den 04.11.2009, 10:18 -0500 schrieb Greg Freemyer:
> >> On Wed, Nov 4, 2009 at 9:26 AM, Alexey Fisher
> >> <bug-track@fisher-privat.net> wrote:
> >> > Hallo,
> >> > this is sort of continue of discussion about unified way to mount fs
> >> > readonly.
> >> > I wont to know how about dmesg/printk. I see ext[234] produce different
> >> > logs on mount even it use same code. I feel like i have some time to
> >> > digg in. My target is easy to parse dmesg.
> >>
> >> Patches for unified mount messages already exist.  Various versions
> >> have been posted in the last couple months.
> >>
> >> I don't know if they have been accepted yet or not.
> >
> > Can you point me this patch?
> > I found only "add a message in remount/umount for ext4"
> > http://patchwork.ozlabs.org/project/linux-ext4/list/?page=1
> 
> Looks like Toshiyuki Okajima is the author.
> 
> http://markmail.org/message/ghyjee2krfmgtybt was just posted in the
> last day or two.
> 
> That patch only adds the new unified dmesg print to the vfs layer.  I
> think there were other patches that removed the scattered prints from
> the various individual filesystems.

Great, look really nice :)
but this is not all what i mean.
For example fs specific messages: EXT4-fs blabla, if you look to source
you'll see "EXT3 FS" "EXT II FS" (fat is worse), if you need to grep it
will be nightmare. It seems like ext4 is mostly up to date, ext2/3 need
some work. Are there any work on this?

Alexey


