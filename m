From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [RFC] enable ext4 allocate blocks across group boundary
Date: Thu, 15 Mar 2012 08:52:35 +0800
Message-ID: <CAGBYx2aETBVb2hMyEBC91meRwr_Z+cnMNwF+ZBU4nk1PdedygA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51203 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031430Ab2COAwg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Mar 2012 20:52:36 -0400
Received: by gghe5 with SMTP id e5so2502128ggh.19
        for <linux-ext4@vger.kernel.org>; Wed, 14 Mar 2012 17:52:35 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello List,

Here is a proposal to enable ext4 allocate blocks across group boundary.

Now ext4 allocates blocks within a single block group by locking a
group.   Flex_bg puts metadata blocks together, as a result,it
enlarges contiguous blocks.  So we can enable ext4 allocate blocks
within a flex block group. Inode allocation takes group lock as block
allocation,  I am not sure if we should allocate inode within single
group as before.

If we do this, then the new group boundary will be flex block group
boundary.  I am not sure if it is worth doing.


Any ideas?

-- 
Best Wishes
Yongqiang Yang
