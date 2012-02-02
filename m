From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: 3.2.2: edquota: WARNING - /dev/md2: cannot change current block allocation
Date: Thu, 2 Feb 2012 19:40:04 -0200
Message-ID: <20267.692.189880.355136@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fisica.ufpr.br ([200.17.209.129]:45779 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098Ab2BBVrt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Feb 2012 16:47:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When I tried to increase the quota of a user (postgres) I got this
edquota warning. The output of quota still showed the * indicating the
limit and the user couldn't allocate more disk. After a reboot (to
3.2.1) and quotacheck I had to use edquota again, and then it accepted
the increase and unblocked the allocations.

This is the output of mount|grep /dev/md2:
/dev/md2 on /home type ext4 (rw,relatime,user_xattr,acl,barrier=0,stripe=128,data=ordered,inode_readahead_blks=64,jqfmt=vfsv1,usrjquota=aquota.user,grpjquota=aquota.group)

How can this be?
