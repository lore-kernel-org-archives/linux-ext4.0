From: "Rohit Sharma" <imreckless@gmail.com>
Subject: block allocation for ext2_mkdir
Date: Fri, 19 Dec 2008 00:12:35 +0530
Message-ID: <2d08ef090812181042k2b15f27fke39076cc72453797@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:14755 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbYLRSui (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 13:50:38 -0500
Received: by wf-out-1314.google.com with SMTP id 27so597793wfd.4
        for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 10:50:36 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

How does ext2 allocate blocks for directory.

ext2_mkdir               calls            ext2_make_empty

ext2_make_empty     calls           __ext2_write_begin

__ ext2_write_begin   calls           block_write_begin

my query is that how does this function allocates blocks for directories. ??
