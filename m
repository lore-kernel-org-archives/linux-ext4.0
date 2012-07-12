From: "Nelson, John R" <John_Nelson@student.uml.edu>
Subject: Bug in filefrag?
Date: Thu, 12 Jul 2012 15:04:44 +0000
Message-ID: <0408C81F72528E40A0D3235A1F67FFC804A4CE@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:25797
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932607Ab2GLPEv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jul 2012 11:04:51 -0400
Received: from mail22-am1 (localhost [127.0.0.1])	by mail22-am1-R.bigfish.com
 (Postfix) with ESMTP id CD2864C0498	for <linux-ext4@vger.kernel.org>; Thu, 12
 Jul 2012 15:04:47 +0000 (UTC)
Received: from AM1EHSMHS010.bigfish.com (unknown [10.3.201.229])	by
 mail22-am1.bigfish.com (Postfix) with ESMTP id B51044A0115	for
 <linux-ext4@vger.kernel.org>; Thu, 12 Jul 2012 15:04:46 +0000 (UTC)
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I did ran filefrag on a 100GB file and it showed it in 82 extents, when i did filefrag -v it went all the way down to 1038 Total extents.. So which is correct? 82 extents or 1038 extents?
