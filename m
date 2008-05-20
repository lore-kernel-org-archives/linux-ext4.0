From: Bas van Schaik <bas@tuxes.nl>
Subject: Reoccurring ext3 errors: attempt to access beyond end of device,
 freeing blocks not in datazone
Date: Tue, 20 May 2008 11:04:26 +0200
Message-ID: <4832941A.70806@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from castor.sshunet.nl ([145.97.192.41]:42833 "EHLO
	castor.sshunet.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763565AbYETJEc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2008 05:04:32 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by castor.sshunet.nl (Postfix) with ESMTP id DCBF257C00D
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 11:04:29 +0200 (CEST)
Received: from castor.sshunet.nl ([127.0.0.1])
	by localhost (castor.sshunet.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gSDWOu+3ZpQO for <linux-ext4@vger.kernel.org>;
	Tue, 20 May 2008 11:04:29 +0200 (CEST)
Received: from guust.tuxes.nl (15pc197.sshunet.nl [145.97.197.15])
	by castor.sshunet.nl (Postfix) with ESMTP
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 11:04:29 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by guust.tuxes.nl (Postfix) with ESMTP id 8B296A80B3
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 11:04:29 +0200 (CEST)
Received: from guust.tuxes.nl ([127.0.0.1])
	by localhost (guust.tuxes.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I9u1H2v6Hri8 for <linux-ext4@vger.kernel.org>;
	Tue, 20 May 2008 11:04:27 +0200 (CEST)
Received: from [192.168.101.4] (15pc197.sshunet.nl [145.97.197.15])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by guust.tuxes.nl (Postfix) with ESMTP id 50778A8094
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 11:04:27 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear all,

First of all, I'm very sorry to post such a vague question. I've been
working this it for months now, but the ext3 errors keep reoccurring
every once in a while. That is, every week or sometimes once a month.
The errors I get in such a situation:

> May 20 09:13:14 infinity kernel: attempt to access beyond end of device
> May 20 09:13:14 infinity kernel: loop0: rw=0, want=15629775440, limit=4404019200
> May 20 09:13:14 infinity kernel: attempt to access beyond end of device
> May 20 09:13:14 infinity kernel: loop0: rw=0, want=13075964688, limit=4404019200
> May 20 09:13:14 infinity kernel: attempt to access beyond end of device
> May 20 09:13:14 infinity kernel: loop0: rw=0, want=15354014352, limit=4404019200
> (...)
>   
and a little bit later:
> May 20 09:15:07 infinity kernel: EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in datazone - block = 1953721929, count = 1
> May 20 09:15:07 infinity kernel: Remounting filesystem read-only
> May 20 09:15:07 infinity kernel: EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in datazone - block = 1634495585, count = 1
> May 20 09:15:07 infinity kernel: EXT3-fs error (device loop0): ext3_free_blocks_sb: bit already cleared for block 543517044
> May 20 09:15:07 infinity kernel: EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in datazone - block = 1919251793, count = 1
> (...)
>   

After running e2fsck everything is fine again for a week or a little
longer...

The situation is not really trivial: I'm importing block devices from
several other machines using ATA over Ethernet (AoE). These block
devices are combined in a set of RAID5 arrays, each of them a physical
volume for LVM. Inside one large LVM volume group there exists a
cryptoloop encrypted logical volume, of which the 'plain' version is
accessible via /dev/loop0.

As you can see, there are a lot of possible failure points, I don't
expect you to identify those for me. I already performed thorough tests
on all servers (from memtest to I/O stressing to networking) and another
point is: this configuration did work flawlessly for about two years!

What I would like to know: what are the possible underlying causes for
the "attempt to access beyond en of device" error? Does anyone see any
meaning in the block (?) numbers mentioned in my syslog?

I would really like to hear from you, this problem is really causing me
headaches!

Regards,

  Bas

