From: Andrey Sidorov <qrxd43@motorola.com>
Subject: Re: [PATCH V2] ext4: speed-up releasing blocks on commit
Date: Fri, 21 Sep 2012 00:43:49 -0400
Message-ID: <CAA0+VHzz-q4moP5P7U4fgru7wqwDwHJyVO1SmTz0NNHwTvGkxQ@mail.gmail.com>
References: <20120921041119.GA4310@qrxd43-motbuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:43431 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2IUEnw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 00:43:52 -0400
Received: from il93mgrg01.am.mot-mobility.com ([10.176.130.20])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id q8L4Yjge025809
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 00:34:46 -0400 (EDT)
Received: from mail-vc0-f174.google.com (mail-vc0-f174.google.com [209.85.220.174])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id q8L4YNEP025634
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 00:34:45 -0400 (EDT)
Received: by mail-vc0-f174.google.com with SMTP id fo13so3502881vcb.19
        for <linux-ext4@vger.kernel.org>; Thu, 20 Sep 2012 21:43:50 -0700 (PDT)
In-Reply-To: <20120921041119.GA4310@qrxd43-motbuntu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 21, 2012 at 12:11 AM, Andrey Sidorov <qrxd43@motorola.com>
wrote:
>
> Improve mb_free_blocks speed by clearing bits all at once instead of going
> one by one.
> Rebuild buddy bitmap by going up only once per range instead of once per
> block.
> For example, for 60G file commit callback time drops from 2.7s to 5ms.
> This is especially good for non-preemptive kernels as there is no
> rescheduling during release.

I realised that current implementation garbles bb_free, bb_counters
and bb_fragments upon double free. I think simplest and the only
reliable way to recover is rebuild buddy off bitmap and that's what I
did.
Tested it with AGGRESSIVE_CHECK defined and mb_check_buddy running at
each invocation. I've also injected bit flips into mb_free_blocks to
ensure regeneration is successful.
