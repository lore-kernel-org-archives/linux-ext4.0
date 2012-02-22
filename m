From: Roberto Ragusa <mail@robertoragusa.it>
Subject: Mkfs option to choose where metadata will be stored
Date: Wed, 22 Feb 2012 14:20:32 +0100
Message-ID: <4F44EBA0.5090606@robertoragusa.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtpi4.ngi.it ([88.149.128.104]:53444 "EHLO smtpi4.ngi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab2BVNbQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Feb 2012 08:31:16 -0500
Received: from [127.0.0.1] (unknown [81.174.56.138])
	by smtpi4.ngi.it (Postfix) with ESMTP id 70647422A5
	for <linux-ext4@vger.kernel.org>; Wed, 22 Feb 2012 14:20:33 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, [please CC me, I'm not subscribed]

is there any way to force allocation of metadata to a different device
or to a specific part (e.g. the begin) of the partition?

I see there is -O journal_dev to redirect the journal.
Can I do something different for metadata?

My idea is to have metadata on SSD and data on HDD.
With a linear RAID mapping, I would get a device which is a few GB of
SSD followed by a lot of HDD space.

Alternatively, I'm going to experiment with an approach where a volume group
is done on two PV: one HDD and one SSD. The idea is to create the LV on
the HDD and then move some extents (for example 0,1,64,65,128,129,...) to
the SSD, so that metadata happens to be on the SSD.
>From what I found about the on-disk format, this is highly approximate
and surely inelegant, so I wonder if a simpler solution exists.

Thanks.

-- 
   Roberto Ragusa    mail at robertoragusa.it
