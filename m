From: jingguo yao <yaojingguo@gmail.com>
Subject: Why does journal mode outperforms all other modes when reading and
 writing data at the same time?
Date: Tue, 28 May 2013 22:39:18 +0800
Message-ID: <CANPB7a4A+CbRcNoDc2=G=u8zy+q7ky=pGQxAMJrbxPC3sfytjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58024 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934325Ab3E1OjU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 May 2013 10:39:20 -0400
Received: by mail-wi0-f171.google.com with SMTP id hq7so2571383wib.10
        for <linux-ext4@vger.kernel.org>; Tue, 28 May 2013 07:39:19 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Documentation/filesystems/ext4.txt has the following sentence:

  This mode is the slowest except when data needs to be read from and
  written to disk at the same time where it outperforms all others
  modes.

And the following link talks about it in more details. Can anybody give
the reason?

http://www.ibm.com/developerworks/library/l-fs8/index.html#4

--
Jingguo
