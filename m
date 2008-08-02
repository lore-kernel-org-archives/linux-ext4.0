From: Hugh Dickins <hugh@veritas.com>
Subject: Re: [BUG] 2.6.27-rc1 in ext3_find_entry
Date: Sat, 2 Aug 2008 14:18:01 +0100 (BST)
Message-ID: <Pine.LNX.4.64.0808021352001.15876@blonde.site>
References: <48932F07.9090407@tuffmail.co.uk> <48942E23.7070402@tuffmail.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Rafael Wysocki <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-pm@lists.osdl.org
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:38185 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbYHBNSd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Aug 2008 09:18:33 -0400
In-Reply-To: <48942E23.7070402@tuffmail.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2 Aug 2008, Alan Jenkins wrote:
> Alan Jenkins wrote:
> > ...followed by several secondary BUGs; most happened as I tried to open
> > new Konsole instances.  My computer soon became unusable - X restarted
> > and then froze, but it responded to SysRQs.  It may just have been all
> > my processes dying, but there was more disk activity than I expected.
> >
> > Strictly speaking I was running v2.6.26-8042-gce6fce4, with a two-line
> > patch to fix a different problem (see
> > <http://bugzilla.kernel.org/show_bug.cgi?id=11178>).

(Yes, I owe you for that patch: saved me a bisect, thank you!)

> >
> > In case it matters, this happened some time after a series of maybe 3
> > suspend/resume cycles in quick succession.  As you can see it happened
> > in the middle of running git; I forget exactly what I was doing.
> 
> It happened again.  I didn't get any BUG in ext3 this time; just a
> disabling stream of BUGs in copy_page_c.  They started a few seconds
> after resume.  So I'm now confident that this is triggered by suspend to
> ram.
> 
> I first noticed it after running an ls command (ls /var/cache/polipo),
> which was Killed.  I was running polipo at the time; it wouldn't have
> been the first access to this directory.  However it was probably the
> first access to this directory after the computer was woken from suspend
> to ram.
> 
> I had the same two-line PCI patch applied.  This time it was atop a
> genuine descendant of v2.6.27-rc1, viz v2.6.27-rc1-156-g94ad374.
> 
> I've put the full trace showing all the BUGs at
> <http://www-student.cs.york.ac.uk/~aj504/dmesg-suspend-BUG-copy_page_c.txt>. 

Your first report had twenty oopses of this kind:
[  228.358397] BUG: unable to handle kernel paging request at ffff88004fcXXXXX
[  228.358423] PGD 202063 PUD 8067 PMD 800000004fc03000 
whereas it should be               PMD 800000004fc001e3

Your second report had six oopses of this kind:
[19280.236437] BUG: unable to handle kernel paging request at ffff88004fbXXXXX
[19280.236645] PGD 202063 PUD 8067 PMD 803c85370cfc01e3 
whereas it should be               PMD 800000004fa001e3

Those corrupted PMD entries are why it's crashing: not (or very unlikely
to be) a problem with ext3 or copy_page_c themselves.  But it does seem
likely that it's connected with suspend/resume.

I think I'd try editing my drivers/base/power/main.c, inserting some
tests and printks in suspend_device, suspend_device_noirq, resume_device,
resume_device_noirq (hope they're sensible places: Rafael may have better
advice).

You want to check that the unsigned long at 0xffff8800000083e8
is                                          0x800000004fa001e3
and the unsigned long at                    0xffff8800000083f0
is                                          0x800000004fc001e3
with printk of device name where it goes wrong.

Or you may find I'm wrong and those are different from the start
(changing a page attribute within a 0x200000 range would have to
break up the 0x1e3 entries: I do wonder whether a change of page
attribute might even be responsible).

Hugh
