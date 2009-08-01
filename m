From: David Rientjes <rientjes@google.com>
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743
 __alloc_pages_nodemask
Date: Sat, 1 Aug 2009 12:56:59 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908010231560.1019@chino.kir.corp.google.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.GwE.OIObKB@chimera> <alpine.DEB.2.00.0907261628180.17123@chino.kir.corp.google.com> <200907280021.26320.rjw@sisk.pl> <alpine.DEB.2.00.0907300021330.7540@chino.kir.corp.google.com>
 <alpine.DEB.2.01.0908010046430.5831@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:60035 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbZHAT5M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Aug 2009 15:57:12 -0400
In-Reply-To: <alpine.DEB.2.01.0908010046430.5831@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 1 Aug 2009, Christian Kujau wrote:

> On Thu, 30 Jul 2009 at 00:21, David Rientjes wrote:
> > These patches have made it to Linus' tree, so this issue is resolved.
> 
> I've pulled Linus' tree yesterday, booted, all fine - just now it was the 
> first time I saw a similar WARNING on my box (running -rc kernels 
> for a few months now), see below.
> 
> Is this related to the WARNING in #13666?
> I'm pretty sure the kernel already includes the patches you 
> mentioned, "git show" said "b592972493c38665efd7d429a01b23fcb21e331a". 
> Also, I just pulled again and mm/ was not touched any more.
> 

Your kernel includes the fixes for the __alloc_pages_nodemask() warning 
that was reported in http://bugzilla.kernel.org/show_bug.cgi?id=13666.

> [69973.604263] ------------[ cut here ]------------
> [69973.604340] WARNING: at mm/page_alloc.c:1749 __alloc_pages_nodemask+0x4c4/0x5a0()
> [69973.604422] Hardware name: Lenovo          
> [69973.604468] Modules linked in: fuse acpi_cpufreq nfsd lockd nfs_acl auth_rpcgss sunrpc lm75 hwmon b43 usb_storage usb_libusual mac80211 cfg80211 uhci_hcd tg3 ssb ehci_hcd usbcore libphy nls_base
> [69973.604727] Pid: 15026, comm: mount Not tainted 2.6.31-rc4 #1
> [69973.604781] Call Trace:
> [69973.604831]  [<c1036dda>] ? warn_slowpath_common+0x7a/0xc0
> [69973.604891]  [<c1076be4>] ? __alloc_pages_nodemask+0x4c4/0x5a0
> [69973.604952]  [<c1036e40>] ? warn_slowpath_null+0x20/0x40
> [69973.605072]  [<c1076be4>] ? __alloc_pages_nodemask+0x4c4/0x5a0
> [69973.605152]  [<c106dc72>] ? delayacct_end+0xa2/0xd0
> [69973.605212]  [<c10c6617>] ? __find_get_block+0xa7/0x180
> [69973.605271]  [<c1076d41>] ? __get_free_pages+0x21/0x60
> [69973.605330]  [<c11f02bd>] ? match_number+0x3d/0xc0
> [69973.605387]  [<c1129512>] ? parse_options+0xe2/0x5d0
> [69973.605444]  [<c135116b>] ? out_of_line_wait_on_bit+0xbb/0xf0
> [69973.605506]  [<c10c6ff8>] ? __wait_on_buffer+0x28/0x50
> [69973.605564]  [<c112b5b7>] ? ext4_fill_super+0x457/0x2670

This is a different issue than bug 13666, this is in the ext4 mount code 
(which can also probably happen with other filesystems as well).

What are your mount options?  It appears that they are causing the parser 
to allocate far more memory than it should ever need.
