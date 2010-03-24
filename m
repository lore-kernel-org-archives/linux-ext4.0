From: Evgeniy Ivanov <lolkaantimat@gmail.com>
Subject: ext2/ext3 different block_sizes/i_size/e2fsck question
Date: Wed, 24 Mar 2010 22:27:24 +0300
Message-ID: <e1e08eb01003241227p35e84777q622996b861009ecb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43667 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0CXT10 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 15:27:26 -0400
Received: by bwz1 with SMTP id 1so242212bwz.21
        for <linux-ext4@vger.kernel.org>; Wed, 24 Mar 2010 12:27:24 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Sorry for bothering list with my ext2 questions.
I got into trouble with my ext2 implementation and filesystem with
1024 block size. Sometimes when I write files they're written
correctly (md5sum is the same as original, i_size is correct either),
but e2fsck changes i_size to another values (which breaks files). E.g.
67445000->67446784 or 67445248->67446784. I see that new sizes are
numbers of multiples of 1024.
Strange thing is that I can't reproduce this problem with 2048 and
4096 block sizes. I thought the problem was in trash in unused part of
last block (actually it is zeroed), but then it would be reproduceable
in fs with another block size.
How does ext2 decide to fix that files sizes? Any suggestions?

Thanks in advance for any help.


-- 
Evgeniy Ivanov
