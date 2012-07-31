From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: Questions about dx --- hash conflicts and limit
Date: Tue, 31 Jul 2012 21:12:24 +0800
Message-ID: <5017D9B8.5080103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62741 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2GaNMl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 09:12:41 -0400
Received: by yhmm54 with SMTP id m54so6006822yhm.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 06:12:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear all,

I have 2 questions about dx in ext4:

1) hash conflict

   I walked through the ext4/namei.c, but didn't find any
   code dealing with hash conflicts.

   I wonder if some name hash conflicts, how can they be stored
   and retrieved with the dir ops?

2) limit on size of dir

   For the limit on items of the dir, the dir size is limited
   to a height of 2 HTree: 
   	root node
    	  |
    intermidate node ...
    	|	|
    leaf node...

   Is this right?



Any explanations are welcomed.


thanks,
