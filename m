From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: kernel Oops in ext3 code
Date: Fri, 28 Sep 2007 07:57:43 -0700
Message-ID: <1190991464.10145.0.camel@dyn9047017100.beaverton.ibm.com>
References: <20070927103122.GB27783@gamma.logic.tuwien.ac.at>
	 <1190927903.3872.12.camel@localhost.localdomain>
	 <20070928045456.GM23215@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Norbert Preining <preining@logic.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:36240 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbXI1Oyn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Sep 2007 10:54:43 -0400
In-Reply-To: <20070928045456.GM23215@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-09-28 at 06:54 +0200, Norbert Preining wrote:
> Hi Mingming,
> 
> On Do, 27 Sep 2007, Mingming Cao wrote:
> > Could you please sent the objdump of the ext4_discard_reservation
> > function? It doesn't match what I see here.
> 
> I assume you meant ext3_.... I made
> 	objdump -x -D -s super.o
> (the only place where I found this function in the source code). If you
> want something else, let me know, but a bit more specific. Can I do the
> objdump directly from the kernel image file?
> 

objdump -DlS balloc.o 

would give us ext3_discard_reservation()

Thanks,
Badari
