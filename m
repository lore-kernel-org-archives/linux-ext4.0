From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Thu, 19 Jun 2008 06:40:05 -0700
Message-ID: <485A61B5.90003@linux.intel.com>
References: <4859F075.2050207@linux.intel.com> <21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com> <20080619081146.GC17630@cs181133002.pp.htv.fi>
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
Received: from mga10.intel.com ([192.55.52.92]:26058 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754994AbYFSNkT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jun 2008 09:40:19 -0400
In-Reply-To: <20080619081146.GC17630@cs181133002.pp.htv.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adrian Bunk wrote:
> 
> Expect a lot more of this to pop up in the future.
> Should we #error for gcc 4.3.1?
> 

it/s better to find if the gcc guys made a testcase for this bug (they normally do) and
test based on that.
