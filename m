From: "R. Felber" <robert.felber@gmx.de>
Subject: Maybe removal of data=journal
Date: Fri, 02 May 2014 20:46:57 +0200
Message-ID: <0279006b-b361-48a6-8777-e7a1cf565c92@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50758 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbaEBSrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 May 2014 14:47:01 -0400
Received: from [172.20.10.10] ([2.201.2.6]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0LmKOI-1XEoHx19pC-00ZwrO for
 <linux-ext4@vger.kernel.org>; Fri, 02 May 2014 20:46:59 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Please don't remove this.

There are situations where I don't want to use directio but want to be sure that I can recover from journal.

I use sync,data=journal for guaranteed transactions.

Correct me, if this is pointless.

-- 
   Rob
