From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [BUG] ext4 trace events cause NULL pointer dereferences
Date: Fri, 23 Jul 2010 17:19:04 +0800
Message-ID: <4C495E88.8080106@cn.fujitsu.com>
References: <20100722054957.GA11670@infradead.org> <20100723011315.GC16373@thunk.org> <20100723144549.88BA.A69D9226@jp.fujitsu.com> <4E28BC9A-BB77-45BC-862A-29601EF4AE2C@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Christoph Hellwig <hch@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53516 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab0GWJOP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jul 2010 05:14:15 -0400
In-Reply-To: <4E28BC9A-BB77-45BC-862A-29601EF4AE2C@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Jul 23, 2010, at 1:47 AM, KOSAKI Motohiro wrote:
> 
>> I'm not familiar ext4 so much. but you patch seems very nice!
>> thank you :)
> 
> So, can someone confirm that this fixes the NULL pointer dereference?  The patch itself makes sense, and it doesn't change the tracepoint output, so I'm inclined to include it, but I haven't been able to reproduce the failure myself using the reproduction recipe given at the beginning of this thread --- and I'd feel much better if someone who has been able to reproduce the crash can confirm this fixes things for them.
> 

Thanks for the fix. I'll test the patch after the weekend.

