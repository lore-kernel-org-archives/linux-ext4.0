From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Thu, 19 Jun 2008 08:18:39 -0700
Message-ID: <485A78CF.7050401@linux.intel.com>
References: <4859F075.2050207@linux.intel.com> <21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com> <20080619081146.GC17630@cs181133002.pp.htv.fi> <485A61B5.90003@linux.intel.com> <20080619151016.GA2721@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Airlie <airlied@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15248 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbYFSPSw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jun 2008 11:18:52 -0400
In-Reply-To: <20080619151016.GA2721@cs181133002.pp.htv.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adrian Bunk wrote:
> On Thu, Jun 19, 2008 at 06:40:05AM -0700, Arjan van de Ven wrote:
>> Adrian Bunk wrote:
>>> Expect a lot more of this to pop up in the future.
>>> Should we #error for gcc 4.3.1?
>> it/s better to find if the gcc guys made a testcase for this bug (they normally do) and
>> test based on that.
> 
> The gcc Bugzilla contains a testcase.
> 
> But how do you plan to integrate it into a kernel build?

we already have several of these.
Just look at scripts/gcc-x86_64-has-stack-protector.sh for an example of such a beast.
