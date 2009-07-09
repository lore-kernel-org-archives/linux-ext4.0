From: Manuel Benitez <rickyb@google.com>
Subject: Tool to view extent metadata
Date: Thu, 9 Jul 2009 15:17:00 -0700
Message-ID: <23904f640907091517w10608fa4y9b3b8b3a631217c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:48588 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZGIWRE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jul 2009 18:17:04 -0400
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id n69MH2e1010442
	for <linux-ext4@vger.kernel.org>; Thu, 9 Jul 2009 15:17:02 -0700
Received: from pzk4 (pzk4.prod.google.com [10.243.19.132])
	by zps19.corp.google.com with ESMTP id n69MH0la006979
	for <linux-ext4@vger.kernel.org>; Thu, 9 Jul 2009 15:17:00 -0700
Received: by pzk4 with SMTP id 4so287698pzk.7
        for <linux-ext4@vger.kernel.org>; Thu, 09 Jul 2009 15:17:00 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm currently evaluating the ext4 allocator and one thing I've come
across is the lack of a tool that displays the exact structure of the
extents making up a file. I've found plenty of tools that will tell me
how many contiguous segments a file contains, but nothing so far to
let me see the actual makeup of the extents that map the inode to the
blocks that comprise the file. Have I just missed something obvious,
or would this be something worth me spending some time doing?

If so, one option would be to either modify the stat command or add a
similar command in debugfs to show the extents from the roots through
the root down to the leafs. Anyone have preferences or opinions?

Thanks,
-Ricky
