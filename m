From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: question about punch hole
Date: Fri, 26 Aug 2011 10:53:27 +0800
Message-ID: <CAGBYx2abeJQBuZDV11WtrprmareZWSNkv-HGdLMvYoMB36mqZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37355 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1HZCx1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Aug 2011 22:53:27 -0400
Received: by pzk37 with SMTP id 37so3498953pzk.1
        for <linux-ext4@vger.kernel.org>; Thu, 25 Aug 2011 19:53:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Allison,

Currently, punch hole flushes all pages to disk and releases pages in
page cache, and then calls ext4_ext_map_blocks.

Assume that if a new page in the punching's range is mapped after
releasing pages and before down_write i_data_sem,
then ext4_ext_map_blocks will release map info of the page in extent
tree.  However, up layers does not know this, and they think the page
is mapped.

I can not find how punch hole handle the situation above.  Could you
shed a light on it?


-- 
Best Wishes
Yongqiang Yang
