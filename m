From: supersud501 <supersud501@yahoo.de>
Subject: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Tue, 08 Apr 2008 19:58:37 +0200
Message-ID: <47FBB24D.90807@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n38.bullet.mail.ukl.yahoo.com ([87.248.110.171]:44701 "HELO
	n38.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751894AbYDHSOe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2008 14:14:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

i get this when trying to run e2fsck on my ext4dev filesystem (kernel 
2.6.25-rc8), extents enabled:

e2fsck 1.40.8 (13-Mar-2008)
/dev/loop2 has unsupported feature(s): huge_file
e2fsck: Get a newer version of e2fsck!

just updated to the git-version of e2fsprogs, same error. i know e2fsck 
worked once with the drive (~2 months ago).

what can i do?

regards,
supersud501

