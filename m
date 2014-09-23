From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: Call trace in ext4_es_lru_add on 3.10 stable
Date: Tue, 23 Sep 2014 09:50:25 +0200
Message-ID: <54212641.9010808@profihost.ag>
References: <541AD93A.70203@profihost.ag> <20140918192131.GD19520@thunk.org> <541B32A1.3080706@profihost.ag> <20140918194311.GE19520@thunk.org> <541FC817.7030401@profihost.ag> <20140922164715.GB4572@thunk.org> <54206AA2.1050607@profihost.ag> <20140922202004.GF4572@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"p.herz@profihost.ag >> Philipp Herz - Profihost AG"
	<p.herz@profihost.ag>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:45020 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaIWHu1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Sep 2014 03:50:27 -0400
In-Reply-To: <20140922202004.GF4572@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Am 22.09.2014 um 22:20 schrieb Theodore Ts'o:
> On Mon, Sep 22, 2014 at 08:29:54PM +0200, Stefan Priebe wrote:
>> Hi,
>> Am 22.09.2014 18:47, schrieb Theodore Ts'o:
>>> On Mon, Sep 22, 2014 at 08:56:23AM +0200, Stefan Priebe wrote:
>>>>> That's not the whole message; you just weren't able to capture it all.
>>>>> How are you capturing these messages, by the way?  Serial console?
>>>>
>>>> Sorry this was an incomplete copy and paste by me.
>>>>
>>>> Here is the complete output:
>>>> [1578544.839610] BUG: soft lockup - CPU#7 stuck for 22s! [mysqld:29281]
>>>> [1578544.893450] Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4
>>>
>>> OK, thanks, this is a known bug, where when ext4 is under heavy memory
>>> pressure, we can end up stalling in reclaim.  This message indicates
>>> that the system got stalled for 22 seconds, which is not good, since
>>> it impacts the interactivity of your system, and increases the
>>> long-tail latency of requests to servers running on your system, but
>>> it doesn't cause any data loss or will cause any of your processes to
>>> crash or otherwise stop functioning (except for temporarily).
>>>
>>> It's something that we are working on, and there are patches which
>>> Zheng Liu submitted that still need a bit of polishing, but I hope to
>>> have it addressed soon.
>>
>> Thanks for your feedback. Will those patches go to stable? Any link to
>> those patches?
> 
> I'm not sure they will go to Stable when they are ready, because the
> patches are somewhat complex and so they may not apply cleanly to much
> older kernels.
> 
> The patches under discussion (some have been applied, others hae been
> waiting for some requested changes) can be found here:
> 
> http://patchwork.ozlabs.org/patch/377720
> http://patchwork.ozlabs.org/patch/377721
> http://patchwork.ozlabs.org/patch/377722
> http://patchwork.ozlabs.org/patch/377723
> http://patchwork.ozlabs.org/patch/377724
> http://patchwork.ozlabs.org/patch/377725
> http://patchwork.ozlabs.org/patch/377727

hui that's a lot. Are they ALL needed to fix this? No workaround
possible? What will Redhat do with their 3.10 RHEL 7 kernel?

Stefan
