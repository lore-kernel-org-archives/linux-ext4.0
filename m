From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/4] ext3: crossport ext3 sb_lock changes
Date: Mon, 14 Dec 2009 12:55:56 -0600
Message-ID: <4B268A3C.8060708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756692AbZLNSzx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 13:55:53 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I ran into a deadlock in ext3 resize due to orphan list manipulation
and filesystem resizing both wanting to grab the sb_lock, and stepping
on each other.

This patch series backports 4 ext4 commits to ext3, pretty trivial
changes to un-overload the superblock lock.

Thanks,
-Eric
