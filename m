From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 0/3][RFC](Repost) add a message in mount/remount/umount for
 ext2/ext3/ext4
Date: Wed, 30 Sep 2009 15:45:03 +0900
Message-ID: <20090930154503.8e3f791e.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu, akpm@linux-foundation.org, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41435 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZI3GvY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 02:51:24 -0400
Received: from m1.gw.fujitsu.co.jp ([10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n8U6pRlR016522
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Wed, 30 Sep 2009 15:51:27 +0900
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id EAC4545DE5C
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:51:26 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id B038345DE5B
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:51:26 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 926621DB803A
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:51:26 +0900 (JST)
Received: from m106.s.css.fujitsu.com (m106.s.css.fujitsu.com [10.249.87.106])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 308BFE38005
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:51:26 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

Under the current implementation, we cannot know in the system log 
(/var/log/messages) when the filesystem (ext2/ext3/ext4) is unmounted.
For enterprise users, they often want to observe certain filesystems'
actions (mount/unmount) in the system log. Besides, by the system log, 
we occasionally wants to know whether a certain filesystem has been
unmounted or not at the time when a problem happens.

The following patch series implement above demand. 
Please apply it.

P.S.
This mail is reposted. 
But I received several comments for the previous mail.
Thanks to Andreas, Eric and Andrew.
I don't modify "PATCH 1/3" and "PATCH 3/3".
But I modify "PATCH 2/3".

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext2/super.c |   15 +++++++++++++++
 fs/ext3/super.c |   30 +++++++++++++++++++++---------
 fs/ext4/super.c |   30 ++++++++++++++++++++++--------
 3 files changed, 58 insertions(+), 17 deletions(-)
