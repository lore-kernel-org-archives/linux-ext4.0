From: jim owens <owens6336@gmail.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag
 (EXT4_IOC_MOVE_EXT) in 32bit compat mode)
Date: Mon, 08 Mar 2010 11:22:15 -0500
Message-ID: <4B952437.8020607@gmail.com>
References: <201003072132.10579.borntraeger@de.ibm.com> <4B94367E.9080506@garzik.org> <201003080853.42978.borntraeger@de.ibm.com> <4B9518DA.8010201@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
	Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
To: David Newall <davidn@davidnewall.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36391 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab0CHQWW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Mar 2010 11:22:22 -0500
In-Reply-To: <4B9518DA.8010201@davidnewall.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

David Newall wrote:
> Christian Borntraeger wrote:
>> Some bigger things are missing in the e4defrag tool:
>> ...
>> - overall layout considerations (e.g. putting files close to its
>> directory or
>>   use the atime to move often used files to the beginning of a disk etc.)
> 
> Shouldn't oft-used files be placed closer to the middle?  If you place
> them at the beginning of the file, it's only possible for the head-stack
> to be close to the file from the inner direction.  Place them in the
> middle and it's possible for the head-stack to be close from the outer
> direction, too, which sounds like a doubling of probability.  It seems
> that it's the least frequently used files that should be placed at one
> end of the disk or the other.

No.  Your logic would be correct if rotating disks had
similar speed at all locations.  Current disks are much
faster at the 0 end than at the middle or highest address.

It is not unusual to see 2x difference in transfer speed
so you always want the important stuff as low as possible.

jim
