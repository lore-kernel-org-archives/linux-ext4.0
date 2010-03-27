From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/3] ext4/quota: journalled quota optimizations
Date: Sat, 27 Mar 2010 15:15:37 +0300
Message-ID: <1269692140-5375-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45575 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab0C0MPx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Mar 2010 08:15:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch set aimed to get rid of most annoying locks.
In case of journalled quota it is dq_iomutex and i_mutex.
Patches are simple and clean. Patches make difference
between nojournaled/journaled quota modes less significant.
And allow us to switch to default journalled quota without
performance penalty.

There are many other optimizations possible, but they are 
more intrusive and require wide discussions.


