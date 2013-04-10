From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: something's using space, can't figure out what - how to debug?
Date: Wed, 10 Apr 2013 19:56:06 +0900
Message-ID: <20130410195606.22a9eff3@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:60927 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab3DJLGK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Apr 2013 07:06:10 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 374A134BCE6
	for <linux-ext4@vger.kernel.org>; Wed, 10 Apr 2013 12:56:17 +0200 (CEST)
Received: from localhost (w0109-49-133-47-51.uqwimax.jp [49.133.47.51])
	by mail.virtall.com (Postfix) with ESMTPSA id F30F034BCCF
	for <linux-ext4@vger.kernel.org>; Wed, 10 Apr 2013 12:56:15 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here is one of my ext4 filesystems, which uses 2x more space as it
should:

# df -h /srv
Filesystem            Size  Used Avail Use% Mounted on
/dev/xvdf             194G  134G   51G  73% /srv

# du -sh /srv/
60G     /srv/

# lsof -n|grep /srv
# 


So df says 134 GB is used, while du says 60 GB is used.
No removed but used files, according to lsof.

How do I best debug what happened to ~70 GB?

This is EC2 kernel, nothing interesting in dmesg:

# uname -a
Linux ec2.agenteimovel.com.br 3.0.0-12-virtual #20-Ubuntu SMP Fri Oct 7
18:19:02 UTC 2011 x86_64 GNU/Linux


-- 
Tomasz Chmielewski
http://www.ptraveler.com
