From: coly <colyli@gmail.com>
Subject: which tree should I generate the ext4 patch ?
Date: Wed, 23 May 2007 17:00:43 +0800
Message-ID: <1179910843.4119.33.camel@coly-t43.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:41509 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849AbXEWJAD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 May 2007 05:00:03 -0400
Received: by ug-out-1314.google.com with SMTP id 70so463302ugb
        for <linux-ext4@vger.kernel.org>; Wed, 23 May 2007 02:00:02 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, list

These days, I am tring to post my patch for inode reservation on
linux-ext4. But I am confused on which tree I should generate the patch.

I worked on mm-tree. But now Thoedore creates a tree for ext4, so should
I generate the patch based on tso-tree ?

Same question to e2fsprogs. I guess maybe I should generate the patch
for e2fsprogs based on e2fsprogs-TEST branch, a.k.a 1.40-WIP-0407. Isn't
it ?

This information has to be confirmed for me to generate the patch.
Thanks for anyone replys me :-)


Best regards.

Coly
