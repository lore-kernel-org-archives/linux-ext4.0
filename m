From: "Nelson, John R" <John_Nelson@student.uml.edu>
Subject: Commit Interval and Delayed Allocation
Date: Sat, 10 Nov 2012 00:40:42 +0000
Message-ID: <0408C81F72528E40A0D3235A1F67FFC83ECD9881@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:11682
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779Ab2KJAkr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Nov 2012 19:40:47 -0500
Received: from mail16-co1 (localhost [127.0.0.1])	by mail16-co1-R.bigfish.com
 (Postfix) with ESMTP id 1023D3A0282	for <linux-ext4@vger.kernel.org>; Sat, 10
 Nov 2012 00:40:46 +0000 (UTC)
Received: from CO1EHSMHS011.bigfish.com (unknown [10.243.78.237])	by
 mail16-co1.bigfish.com (Postfix) with ESMTP id 9ED2F500049	for
 <linux-ext4@vger.kernel.org>; Sat, 10 Nov 2012 00:40:43 +0000 (UTC)
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
  Say if ext4 commits every 5 seconds, does this mean whatever is buffered for delayed allocation is flushed every 5 seconds as well?
