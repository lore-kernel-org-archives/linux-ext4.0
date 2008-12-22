From: Andreas Dilger <adilger@sun.com>
Subject: Re: Ext4 documentation
Date: Mon, 22 Dec 2008 16:44:56 -0700
Message-ID: <20081222234456.GW5000@webber.adilger.int>
References: <20081222235841.7aaaef93@diego-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42727 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbYLVXpM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Dec 2008 18:45:12 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mBMNjBSg016967
	for <linux-ext4@vger.kernel.org>; Mon, 22 Dec 2008 15:45:11 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KCA00101XSKXD00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 22 Dec 2008 15:45:11 -0800 (PST)
In-reply-to: <20081222235841.7aaaef93@diego-desktop>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 22, 2008  23:58 +0100, Diego Calleja wrote:
> Due to the astounding lack of good end-user documentation about Ext4, I've
> taken the freedom of writing an article about it for the kernelnewbies
> 2.6.28 changelog: http://kernelnewbies.org/Ext4
> 
> If you find any error or you have some suggestion, just tell me and I'll
> fix it.

Looks pretty good, thanks for writing this up.  Minor notes:
- While > 16TB is supported by ext4 disk formats, the mke2fs/e2fsck code
  to support this is not in any released e2fsprogs yet
- I don't think the journal async commit blocks are enabled by default, so
  the "20% speedup" is not available yet.  There is some work that
  needs to be done to make this feature 100% safe in case of corruption.
- I'm not sure if enabling flex_bg on an existing ext3 filesystem is useful
- you don't mention anything about the required e2fsprogs version.  I
  _think_ (someone should confirm) that e2fsprogs-1.41.3 is the minimum
  version that anyone should use.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

