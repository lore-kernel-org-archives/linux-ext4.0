From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: tune2fs and setting noatime as a default mount options
Date: Fri, 29 Aug 2014 00:12:27 +0200
Message-ID: <16b17d3bf6a5952c3f20a8644be22c58@admin.virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:48911 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbaH1WTx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Aug 2014 18:19:53 -0400
Received: from mailext.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id EE3AE35EA5B
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2014 00:12:27 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'd like to set noatime as a default mount option for a filesystem:

# tune2fs -o noatime /dev/sdb1
tune2fs 1.42.9 (4-Feb-2014)
Invalid mount option set: noatime


Is there a reason why noatime can't be set as a default mount option? 
Thinking of all these USB connected devices where it would be handy.


-- 
Tomasz Chmielewski
http://www.sslrack.com

