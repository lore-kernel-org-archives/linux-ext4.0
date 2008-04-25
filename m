From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Fri, 25 Apr 2008 10:02:00 +0200
Message-ID: <48118FF8.2080204@gmail.com>
References: <alpine.LFD.1.10.0804241841280.2779@woody.linux-foundation.org>	<20080424.185757.254044977.davem@davemloft.net>	<48118B18.5020008@gmail.com> <20080425.004523.146850490.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com,
	mingo@elte.hu, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	johannes@sipsolutions.net, flamingice@sourmilk.net, jbenc@suse.cz
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:8884 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758004AbYDYICF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 04:02:05 -0400
Received: by fg-out-1718.google.com with SMTP id l27so3495671fgb.17
        for <linux-ext4@vger.kernel.org>; Fri, 25 Apr 2008 01:02:04 -0700 (PDT)
In-Reply-To: <20080425.004523.146850490.davem@davemloft.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/25/2008 09:45 AM, David Miller wrote:
> I notice Jiri, in your hardware list, you have an ath5k Atheros AR5212 chip
> in there.
> 
> I took a look at the resume code for ath5k but nothing really suspicious
> there except:
> 
> 	err = pci_enable_device(pdev);
> 	if (err)
> 		return err;
> 
> 	pci_restore_state(pdev);
> 
> Shouldn't we restore state before we turn the chip back on and thus
> potentially let it start DMA'ing all over the place?

Hmm, I cut&pasted that code from somewhere, it seems to be broken. Anyway it 
worked for a half a year or so. Mending locally. Thanks.
