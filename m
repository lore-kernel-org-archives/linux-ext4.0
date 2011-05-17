From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Use of consistent types in e2fsprogs
Date: Tue, 17 May 2011 08:32:49 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105170830040.3449@dhcp-27-109.brq.redhat.com>
References: <DC591D7D-86E5-4FA6-BC8F-859F1965C51D@dilger.ca> <20110517011648.GC4953@thunk.org> <DAA9FED5-9ACE-40A0-8AF4-70B4C7648976@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab1EQGcy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2011 02:32:54 -0400
In-Reply-To: <DAA9FED5-9ACE-40A0-8AF4-70B4C7648976@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I'm not suggesting a global search & replace of "long long" or anything.
> However, the current mish-mash of int vs. long vs. dgrp_t for group numbers,
> __u64 vs blk64_t, etc doesn't make it clear when something is intentionally
> that type, or just happens to be working for now.  Having separate types
> for groups vs. physical blocks vs. logical blocks as we do in the kernel
> will improve the quality of the code itself, I think.
> 
> Cheers, Andreas
> 

I have to agree with Andreas here, types in e2fsprogs are not consistent
and I have encounter this several times, trying to decide which one is
the best, looking for examples, and finding different uses in different
parts of e2fsprogs tools. It is a mess. I think it is worth the core crunch
I someone is willing to do the job.

Thanks!
-Lukas
