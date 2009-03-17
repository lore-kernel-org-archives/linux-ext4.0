From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Overwriting w/ discard-capable drive causes soft-lockup in ext4
 	journal code, 2.6.28.8
Date: Tue, 17 Mar 2009 13:01:22 -0500
Message-ID: <49BFE572.9020302@redhat.com>
References: <f3177b9e0903171029l13e7dbafyba30ece01172ce6d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758019AbZCQSB0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Mar 2009 14:01:26 -0400
In-Reply-To: <f3177b9e0903171029l13e7dbafyba30ece01172ce6d@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Chris Worley wrote:
> The issue I'm seeing is caused by running this repeatedly on an ext4
> fs (2.6.28.8 kernel) w/ discards enabled (a ram-based MTD device
> contains the fs):
> 
> while `true`
> do  i=0
>      while [ $i -lt 100 ]
>      do dd of=foo"$i" if=/dev/zero bs=1024k oflag=direct &
>           let i=$i+1
>      done
>      wait
> done
> 
> (Note: the loop is intended to fill-up the fs w/ 100 dd threads...
> successive re-runs of the loop will rewrite the same files from
> scratch.)
> 
> ... It causes "soft-lockup" issues on successive iterations,
> immediately as the DD's are launched, as previous foo files get their
> blocks discarded.

I need to find a machine w/ more memory to test on :)  but with a device
of half that size, on 2.6.29-rc7 machine w/ 2 cpus and 2G ram, I'm not
seeing it...

Any chance you can try a 2.6.29-rcX kernel just to double-check?

Thanks,
-Eric
