From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 0/3][RFC] add a message in mount/remount/umount for
 ext2/ext3/ext4
Date: Tue, 15 Sep 2009 15:20:39 +0900
Message-ID: <20090915152039.fdca8936.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@sun.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57494 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbZIOGYs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Sep 2009 02:24:48 -0400
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n8F6OpCV003022
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Tue, 15 Sep 2009 15:24:51 +0900
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id CD00845DE5B
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 15:24:50 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id A7ADC45DE52
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 15:24:49 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 47570E38006
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 15:24:49 +0900 (JST)
Received: from m107.s.css.fujitsu.com (m107.s.css.fujitsu.com [10.249.87.107])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id BFB251DB8043
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 15:24:48 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, Andrew and all.

Under the current implementation, we cannot know in the system log 
(/var/log/messages) when the filesystem (ext2/ext3/ext4) is unmounted.
For enterprise users, they often want to observe certain filesystems'
actions (mount/unmount) in the system log. Besides, by the system log, 
we occasionally wants to know whether a certain filesystem has been
unmounted or not at the time when a problem happens.

The following patch series implement above demand. 
Please apply it.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext2/super.c |   16 ++++++++++++++++
 fs/ext3/super.c |   32 +++++++++++++++++++++++---------
 fs/ext4/super.c |   30 ++++++++++++++++++++++--------
 3 files changed, 61 insertions(+), 17 deletions(-)

Regards,
Toshiyuki Okajima
