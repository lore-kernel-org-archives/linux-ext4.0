From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix for consistency errors after crash
Date: Tue, 06 Jul 2010 11:00:43 -0500
Message-ID: <4C33532B.8010009@redhat.com>
References: <AANLkTimYavpuyNiaKYqUe3LFp0uzix_-ITV9ao0VagLs@mail.gmail.com> <AANLkTilxxsCSTIFLzg95xooW70SCNfWiDUVqpAT32FbX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab0GFQA5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jul 2010 12:00:57 -0400
In-Reply-To: <AANLkTilxxsCSTIFLzg95xooW70SCNfWiDUVqpAT32FbX@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Amir G. wrote:
> Hi Eric,
> 
> I've seen you guys had some open RH bugs on ext3, who all share in
> common the "bit already free" error.
> 
> This bug I reported can explain many different problems in ext[34].
> 
> Essentially, every time there is a kernel crash (or hard reboot)
> during delete/truncate of a large file,
> it may result in "bit already clear" error after reboot.
> 
> The problem is very simple and so is the fix.
> I proved the problem with 100% recreation chances using a small patch,
> instead of running statistical stress tests.
> All I did was to add a print and 10 seconds delay after transaction
> restart in ext3_free_branches and reboot > 5 seconds after the
> transaction restarts, so that kjournald will have time to commit the
> old transaction.
> After the reboot, I always get "bit already clear" errors, because the
> "half large truncate" transaction is not handled properly.
> 
> I did not get any response from ext4 guys so far and since this bug
> dates back to ext3,
> I was hoping you guys could take a look and put your weight on pushing
> the fix upstream.

Hi Amir, I really do appreciate the effort, the patch, and the ping.  :)

I'll have to set aside some time to give it a hard look, but linking
it back to existing bugs of mine raises that priority, thanks.  :)

-Eric

> Thanks,
> Amir.
