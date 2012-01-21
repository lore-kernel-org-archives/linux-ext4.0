From: Robin Dong <hao.bigrat@gmail.com>
Subject: Question about writable ext4-snapshot
Date: Sat, 21 Jan 2012 10:45:27 +0800
Message-ID: <CAFZ0FUWzq4GV-Xi6n+8+5R+oVi8uPBFg6XHzgwZfXVP_FbMz=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tao Ma <taoma.tm@gmail.com>, coly <colyli@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: amir73il@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:49216 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753279Ab2AUCp1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jan 2012 21:45:27 -0500
Received: by obcva7 with SMTP id va7so1437497obc.19
        for <linux-ext4@vger.kernel.org>; Fri, 20 Jan 2012 18:45:27 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello, Amir

I am evaluating ext4-snapshot (on github) for TAOBAO recently. The
snapshot of an ext4 fs is READONLY now, but we do need to write data
into snapshot. We also want using  ext4-snapshot to do online-fsck on
Hadoop clusters, but our hadoop clusters are using no-journal ext4
now. So we have some question

1. Will it be possible to implement a writable ext4-snapshot ?
2. Will it be possible to snapshot a no-journal ext4-fs ?
3. What's the difficult point of  implementing above ?

Any of your reply will be appreciate

-- 
--
Best Regard
Robin Dong
