From: Vasily Averin <vvs@sw.ru>
Subject: dead code: EXT3_IOC_WAIT_FOR_READONLY?
Date: Fri, 16 Mar 2007 14:16:28 +0300
Message-ID: <45FA7C8C.2010904@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>,
	Andreas Dilger <adilger@clusterfs.com>, devel@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:39667 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbXCPLSn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Mar 2007 07:18:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

I've found some strange ext3 ioctl under CONFIG_JBD_DEBUG:
EXT3_IOC_WAIT_FOR_READONLY.

I had DEBUG_SPINLOCK enabled and my kernel was crashed on wait-for-readonly.c
test from ext3-tools because ioctl handler tries to use uninitialized
EXT3_SB(sb)->ro_wait_queue and waits EXT3_SB(sb)->turn_ro_timer that nobody uses
in kernel.

I do not understand the function of this ioctl and believe this code is dead
long time ago. From my POV it makes sense to remove it from kernel instead of
fixing it. Has somebody any objections?

Thank you,
	Vasily Averin
