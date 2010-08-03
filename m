From: =?ISO-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>
Subject: persistent preallocation
Date: Tue, 3 Aug 2010 12:58:21 +0200 (CEST)
Message-ID: <Pine.A41.4.64.1008031256060.1073402@stalin.acc.umu.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.acc.umu.se ([130.239.18.156]:60808 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949Ab0HCK6Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Aug 2010 06:58:24 -0400
Received: from localhost (localhost [127.0.0.1])
	by amavisd-new (Postfix) with ESMTP id 83157DA3
	for <linux-ext4@vger.kernel.org>; Tue,  3 Aug 2010 12:58:22 +0200 (MEST)
Received: from stalin.acc.umu.se (stalin.acc.umu.se [130.239.18.135])
	by mail.acc.umu.se (Postfix) with ESMTP id 9D2EBDA1
	for <linux-ext4@vger.kernel.org>; Tue,  3 Aug 2010 12:58:21 +0200 (MEST)
Received: from localhost (localhost [127.0.0.1])
	by stalin.acc.umu.se (Postfix) with ESMTP id 71C822C
	for <linux-ext4@vger.kernel.org>; Tue,  3 Aug 2010 12:58:21 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello,

I have a question on the implementation of persistent preallocation, the 
reason to not return the disk block is because it can contain old data but 
I wonder if an implementation has to return zeros instead or if it could 
return any garbage as long as it is not _that_ garbage?

Bo Branten

