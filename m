From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: how to quotacheck with the new quota implementation (hidden inode)?
Date: Sat, 19 Jan 2013 00:40:35 -0200
Message-ID: <20730.1955.395545.141779@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fisica.ufpr.br ([200.17.209.129]:41751 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab3ASCsK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2013 21:48:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've started to use the new quota implementation (3.7.3 running now).
I used tune2fs -Q to turn non {usr,grp}quota. It's nice, no need to
run quotaon and all the jquota=file options. It works but it starts
counting only what comes after the mount with the new quota. If there
is already stuff in the filesystem it's not counted. How can we do a
quotacheck?

Also, what happens if the machine crashes without umounting? How is
the usage going to be handled? Is it in the journal? Anyway, it'd also
be important to do a quotacheck.

Is it possible?
