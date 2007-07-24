From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
Date: Tue, 24 Jul 2007 14:30:31 +1000
Message-ID: <46A58067.8070207@yahoo.com.au>
References: <20070721210005.000228000@chello.nl> <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com> <20070722081010.GA6317@mail.ustc.edu.cn> <1185093236.6344.87.camel@localhost.localdomain> <46A46E4B.7050007@yahoo.com.au> <385201377.00678@ustc.edu.cn> <20070723124009.5fcf4fef.akpm@linux-foundation.org> <385238729.01475@ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Dave Jones <davej@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	riel <riel@redhat.com>, Tim Pepper <lnxninja@us.ibm.com>,
	Chris Snook <csnook@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-ext4@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Chris Ahna <christopher.j.ahna@intel.com>,
	David Mosberger-Tang <davidm@hpl.hp.com>,
	Kyle McMartin <kyle@parisc-linux.org>
To: Fengguang Wu <fengguang.wu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:36169 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750858AbXGXEak (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jul 2007 00:30:40 -0400
In-Reply-To: <385238729.01475@ustc.edu.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fengguang Wu wrote:
> On Mon, Jul 23, 2007 at 12:40:09PM -0700, Andrew Morton wrote:

>>This is all fun stuff, but how do we find out that changes like this are
>>good ones, apart from shipping it and seeing who gets hurt 12 months later?
> 
> 
> One thing I can imagine now is that the first pages may get more life
> because of the conservative initial readahead size.

Yeah I don't think it is really worth the complexity and corner cases
it would introduce at this stage.

People are still complaining about their nightly cron job *swapping*
stuff out of their 1-2GB desktop systems. There must still be some low
hanging fruit or obvious problems with page reclaim so I'd like to try
working out exactly what is going wrong and fix it in page reclaim
rather than adding more complexity in the hope that it might help.

-- 
SUSE Labs, Novell Inc.
