From: Christoph Bartoschek <bartoschek@or.uni-bonn.de>
Subject: Ext4 quota support
Date: Mon, 28 Mar 2011 10:57:15 +0200
Message-ID: <4D904D6B.2020201@or.uni-bonn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brical.or.uni-bonn.de ([131.220.141.99]:35102 "EHLO
	brical.or.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab1C1JYl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Mar 2011 05:24:41 -0400
Received: from wse04.or.uni-bonn.de (bg-1.or.uni-bonn.de [131.220.141.100])
	by brical.or.uni-bonn.de (Postfix) with ESMTP id 98AB73B6D6
	for <linux-ext4@vger.kernel.org>; Mon, 28 Mar 2011 10:57:15 +0200 (CEST)
Received: from imap.or.uni-bonn.de (mailserver.or.uni-bonn.de [131.220.143.135])
	by wse04.or.uni-bonn.de (Postfix) with ESMTP id 0BFB2EB19
	for <linux-ext4@vger.kernel.org>; Mon, 28 Mar 2011 10:57:16 +0200 (CEST)
Received: from barney.bruehl.pontohonk.de (wse00.or.uni-bonn.de [131.220.143.130])
	by imap.or.uni-bonn.de (Postfix) with ESMTPS id E32361FF3C
	for <linux-ext4@vger.kernel.org>; Mon, 28 Mar 2011 10:57:15 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

today we had to reboot one of our fileservers with ext4. Unfortunately 
it decided to run a quotacheck on restart. We are now waiting till it 
checked several TB of data.

My question is: Is there a reason why the quotacheck started although 
the server was shut down cleanly?

Another question: Is the first class quota support in ext4 somthing to 
be expected soon or should we better use another filesystem like XFS?

Christoph
