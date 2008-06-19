From: Adrian Bunk <bunk@kernel.org>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Thu, 19 Jun 2008 18:10:18 +0300
Message-ID: <20080619151016.GA2721@cs181133002.pp.htv.fi>
References: <4859F075.2050207@linux.intel.com> <21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com> <20080619081146.GC17630@cs181133002.pp.htv.fi> <485A61B5.90003@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Dave Airlie <airlied@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50648 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbYFSPLy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jun 2008 11:11:54 -0400
Content-Disposition: inline
In-Reply-To: <485A61B5.90003@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 19, 2008 at 06:40:05AM -0700, Arjan van de Ven wrote:
> Adrian Bunk wrote:
>>
>> Expect a lot more of this to pop up in the future.
>> Should we #error for gcc 4.3.1?
>
> it/s better to find if the gcc guys made a testcase for this bug (they normally do) and
> test based on that.

The gcc Bugzilla contains a testcase.

But how do you plan to integrate it into a kernel build?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

