From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: Use fsck to free the space used by dir?
Date: Fri, 03 Aug 2012 22:19:17 +0800
Message-ID: <501BDDE5.8060005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43858 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2HCOTj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2012 10:19:39 -0400
Received: by qcro28 with SMTP id o28so406279qcr.19
        for <linux-ext4@vger.kernel.org>; Fri, 03 Aug 2012 07:19:38 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear all,

I read through the namei.c code recently, but didn't notice any code to
reduce the size of a dir file (append can increase its size though).

I wonder if I create large amount of files under dir A, then remove all
the sub items, do I need to run fsck to free the disk space used by the
dir file? 

Please help confirm or if I missed some points.


Regards,
Sheng-Hui
