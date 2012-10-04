From: =?ISO-8859-1?Q?Holger_Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Repeatable ext4 oops with 3.6.0 (regression)
Date: Thu, 04 Oct 2012 23:11:21 +0200
Message-ID: <506DFB79.1040307@googlemail.com>
References: <pan.2012.10.02.11.19.55.793436@googlemail.com> <20121002133642.GD22777@quack.suse.cz> <pan.2012.10.02.14.31.57.530230@googlemail.com> <20121004130119.GH4641@quack.suse.cz> <506DABDD.7090105@googlemail.com> <20121004173425.GA15405@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:58699 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754988Ab2JDVLZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Oct 2012 17:11:25 -0400
In-Reply-To: <20121004173425.GA15405@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(dear -mm: please see
http://thread.gmane.org/gmane.comp.file-systems.ext4/34665 for the
origins of this oops)

On 10/04/12 19:34, Theodore Ts'o wrote:
> On Thu, Oct 04, 2012 at 05:31:41PM +0200, Holger Hoffst=E4tte wrote:
>=20
>> So armed with multiple running shells I finally managed to save the =
dmesg
>> to NFS. It doesn't get any more complete than this and again shows t=
he
>> ext4 stacktrace from before. So maybe it really is generic kmem corr=
uption
>> and ext4 looking at symlinks/inodes is just the victim.
>=20
> That certainly seems to be the case.  As near as I can tell from the

Good to know. Unfortunately I'm still at a loss why apparently only
gthumb can trigger this; I had not noticed any other problems with 3.6.=
0
before that (ran it for half a day, desktop use).

> So it's very likely that the crash in __kmalloc() is probably caused
> by the internal slab/slub data structures getting scrambled.

=46or giggles I rebuilt with SLAB instead of SLUB, but no luck; same
segfault and delayed oopsie. I also collected an strace, but I cannot
really see anything out of the ordinary - it starts, loads things,
traverses directories and then segfaults.

I've put the earlier full dmesg and the strace into
http://hoho.dyndns.org/~holger/ext4-oops-3.6.0/ - maybe it helps someon=
e
else.

Any suggestions for memory debugging? I saw several options in the
kernel config (under "Kernel Hacking") but was not sure what to enable.

Holger

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
