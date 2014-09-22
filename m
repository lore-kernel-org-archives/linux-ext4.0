From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: Call trace in ext4_es_lru_add on 3.10 stable
Date: Mon, 22 Sep 2014 20:29:54 +0200
Message-ID: <54206AA2.1050607@profihost.ag>
References: <541AD93A.70203@profihost.ag> <20140918192131.GD19520@thunk.org> <541B32A1.3080706@profihost.ag> <20140918194311.GE19520@thunk.org> <541FC817.7030401@profihost.ag> <20140922164715.GB4572@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"p.herz@profihost.ag >> Philipp Herz - Profihost AG"
	<p.herz@profihost.ag>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:37701 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaIVS3y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Sep 2014 14:29:54 -0400
In-Reply-To: <20140922164715.GB4572@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
Am 22.09.2014 18:47, schrieb Theodore Ts'o:
> On Mon, Sep 22, 2014 at 08:56:23AM +0200, Stefan Priebe wrote:
>>> That's not the whole message; you just weren't able to capture it all.
>>> How are you capturing these messages, by the way?  Serial console?
>>
>> Sorry this was an incomplete copy and paste by me.
>>
>> Here is the complete output:
>> [1578544.839610] BUG: soft lockup - CPU#7 stuck for 22s! [mysqld:29281]
>> [1578544.893450] Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4
>
> OK, thanks, this is a known bug, where when ext4 is under heavy memory
> pressure, we can end up stalling in reclaim.  This message indicates
> that the system got stalled for 22 seconds, which is not good, since
> it impacts the interactivity of your system, and increases the
> long-tail latency of requests to servers running on your system, but
> it doesn't cause any data loss or will cause any of your processes to
> crash or otherwise stop functioning (except for temporarily).
>
> It's something that we are working on, and there are patches which
> Zheng Liu submitted that still need a bit of polishing, but I hope to
> have it addressed soon.

Thanks for your feedback. Will those patches go to stable? Any link to 
those patches?

Stefan

>
> Cheers,
>
> 						- Ted
>
