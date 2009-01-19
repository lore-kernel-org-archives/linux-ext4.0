From: Graham Murray <graham@gmurray.org.uk>
Subject: All processes accessing etx4 partition stuck in 'D' state
Date: Mon, 19 Jan 2009 06:47:45 +0000
Message-ID: <87ljt7zt9q.fsf@newton.gmurray.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from newton.gmurray.org.uk ([81.2.114.237]:52885 "EHLO
	newton.gmurray.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbZASHAv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Jan 2009 02:00:51 -0500
Received: from newton.gmurray.org.uk (localhost [127.0.0.1])
	by newton.gmurray.org.uk (8.14.3/8.14.3) with ESMTP id n0J6ljQO003849
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 06:47:45 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I do not know if this is ext4 related or not, so my apologies if it is
not.

I am running the latest linus 2.6.29-rc2 git kernel together with the
master branch of the ext4 git tree announced here a couple of days ago.

Yesterday evening, all processes accessing /home which is formatted as
ext4 (created as ext4 under 2.6.26 with the ext4 patches applied, not
converted from ext3) were stuck in 'D' state and top showed both cores
of the core2 CPU in 100% Waiting state. Everything not accessing /home
was responsive. To eliminate a physical problem I ran a SMART self-test
on the drive containing /home and it passed with no errors. / is also
etx4, but was converted from ext3. There were no kernel messages, just
the hung processes. The system would not reboot normally (because of the
processes in 'D' state), but following sysrq sync, mount r/o and reboot,
the filesystem showed as clean when restarted. To be sure, the first
thing I did was to unmount it and manually ran fsck -f and that did not
report any problems. 
