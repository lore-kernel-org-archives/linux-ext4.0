From: Evgeniy Ivanov <lolkaantimat@gmail.com>
Subject: Question about e2fsck and HTree
Date: Thu, 22 Apr 2010 23:43:30 +0400
Message-ID: <z2ne1e08eb01004221243m89a97acei72316abe62daaba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46406 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab0DVTnc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Apr 2010 15:43:32 -0400
Received: by gwj19 with SMTP id 19so2249230gwj.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Apr 2010 12:43:31 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I have a question about ext2/ext3.

As I understand directory indexing is compatible feature, currently my
implementations doesn't support HTree.
I do some things (make kernel and libs) with FS and check it with
e2fsck: it creates index (everything else is ok, exit status is 1).
Then I do same things with FS and check again:

HTree directory inode 23316 has an invalid root node.

Is it OK for implementation without directory indexing?


-- 
Evgeniy Ivanov
