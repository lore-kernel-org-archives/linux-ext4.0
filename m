From: jim owens <owens6336@gmail.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag
 	(EXT4_IOC_MOVE_EXT) in 32bit compat mode)
Date: Mon, 08 Mar 2010 12:11:17 -0500
Message-ID: <4B952FB5.2060600@gmail.com>
References: <201003072132.10579.borntraeger@de.ibm.com>	 <4B94367E.9080506@garzik.org>	 <201003080853.42978.borntraeger@de.ibm.com>	 <4B9518DA.8010201@davidnewall.com> <4B952437.8020607@gmail.com> <87f94c371003080831n4d310e10i2b9badf4290f1ede@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: David Newall <davidn@davidnewall.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:35707 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab0CHRLW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Mar 2010 12:11:22 -0500
In-Reply-To: <87f94c371003080831n4d310e10i2b9badf4290f1ede@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greg Freemyer wrote:
> 
> Jim, I should know this, but is sector 0 on the outside edge, or the inner edge?
> 
> I assume outer so that the linear speed of the platter under the head
> is faster and thus more data per second is passing under the head.

Correct.  AFAIK everyone starts 0 at the outer edge for that reason,
it makes for better benchmarks ;)

When I only worried about a few OEM drives, I used to read the zone
geometry from the drive to see where each speed transition was as the
density decreased.  But that is just not worth the effort in linux
filesystems IMO, it is enough to pack low.

jim
