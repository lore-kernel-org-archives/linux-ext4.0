From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: RFC Per group orphan list
Date: Wed, 28 Apr 2010 14:55:29 +0400
Message-ID: <87och3q21q.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52202 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab0D1Kzd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Apr 2010 06:55:33 -0400
Received: by bwz19 with SMTP id 19so26994bwz.21
        for <linux-ext4@vger.kernel.org>; Wed, 28 Apr 2010 03:55:32 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently orphan list is global, which require per-sb mutex
to protect add/del from the list. But it is not really necessary.
Just think about it we have to add inode to orphan list for each
->write_begin call(for each page) if i_size will grow.
For example btrfs support per-ctree orphan list.
So IMHO per-group orphan list seems to be more natural here.
So my proposal is following:
1) Introduce new incompat feature for per-group orphan list. 
2) Store per-group head of the list in group descriptor
   (Where are several reserved fields in grp-desc).
3) Maintain per-group orphan which protected by per-group lst-mutex. 
4) Let fsck to scan group descriptors after unclean umount.Since they
   are close to each other performance penalty will be negligible.

Seems that development complexity of this feature is not too high, 
what do you think.
