From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: ext4 memory leak (was Re: [PATCH] x86: _edata should include
	all .data.* sections on X86_64)
Date: Wed, 15 Jul 2009 11:33:15 +0100
Message-ID: <1247653995.10407.25.camel@pc1117.cambridge.arm.com>
References: <4A5C20E5.6010203@fisher-privat.net>
	 <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com>
	 <4A5C41C8.7040904@fisher-privat.net>
	 <1247564356.28240.30.camel@pc1117.cambridge.arm.com>
	 <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
	 <4A5C5A59.5080304@fisher-privat.net>
	 <1247567499.28240.48.camel@pc1117.cambridge.arm.com>
	 <4A5C5FD0.3020204@fisher-privat.net>
	 <1247574390.28240.67.camel@pc1117.cambridge.arm.com>
	 <20090715080336.GA4823@skywalker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Alexey Fisher <bug-track@fisher-privat.net>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41763 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbZGOKdq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jul 2009 06:33:46 -0400
In-Reply-To: <20090715080336.GA4823@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-07-15 at 13:33 +0530, Aneesh Kumar K.V wrote:
> Can you try this patch ?
[...]
>     ext4: Memory leak fix ext4_group_info allocation.
>     
>     commit 5f21b0e642d7bf6fe4434c9ba12bc9cb96b17cf7  was done to
>     reallocate groupinfo struct during resize properly. That goal
>     was to allocate new groupinfo struct when we are adding new block
>     groups during resize. Calling ext4_mb_add_group_info in the
>     mballoc initialization code path resulted in we reallocating
>     the group info struct . Fix this by not separately allocating
>     group info in the mballoc init path and always depend on
>     ext4_mb_add_group_info to allocate group info struct.
>     
>     The earlier code also had a bug that we allocated less number of
>     group info struct for the last meta group. But on resize we
>     expected that we had EXT4_DESC_PER_BLOCK group info struct for
>     each meta group.
>     
>     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

The kmemleak report disappeared.

Tested-by: Catalin Marinas <catalin.marinas@arm.com>

BTW, there are a few compiler warnings about unused variables with this
patch.

-- 
Catalin

