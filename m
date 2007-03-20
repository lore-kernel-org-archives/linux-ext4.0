From: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Subject: Ext4 benchmarks
Date: Tue, 20 Mar 2007 16:20:10 +0100
Message-ID: <45FFFBAA.6080404@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42317 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933736AbXCTPT2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Mar 2007 11:19:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 24A5D19D95C
	for <linux-ext4@vger.kernel.org>; Tue, 20 Mar 2007 16:19:18 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 29479-03 for <linux-ext4@vger.kernel.org>;
 Tue, 20 Mar 2007 16:19:15 +0100 (CET)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 2F20419D95B
	for <linux-ext4@vger.kernel.org>; Tue, 20 Mar 2007 16:19:15 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

we already discussed during the conf calls what
benchmarks should be ran on ext4.

As we have OLS paper on the table we were thinking
here at Bull what bench t run and on which kernel.

If we want trying to compare ext3 and ext4, I guess we
should at least show that :
- ext4 has equivalent perfs than ext3,
- improvements done for ext3 are still in ext4 (mb alloc, del alloc...).

So  we were wondering what's best to do :
- run on 2.6.19 (includes del alloc and mb alloc if I am not wrong),
- run on 2.6.20 (lacks mb alloc),

- select relevant benchs (iozone...).

What do you think ?

Thanks.


jean-pierre

 
