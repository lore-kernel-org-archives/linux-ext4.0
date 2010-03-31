From: Eric Sandeen <sandeen@redhat.com>
Subject: quota reservation fixes for -stable?
Date: Wed, 31 Mar 2010 10:36:12 -0500
Message-ID: <4BB36BEC.2000207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041Ab0CaPgU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Mar 2010 11:36:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I think we should get the following commits to -stable:

0a5a9c725512461d19397490f3adf29931dca1f2 quota: Fix warning when a delayed write happens before quota is enabled
c469070aea5a0ada45a836937c776fd3083dae2b quota: manage reserved space when quota is not active [v2]

without these, we're just racking up the score on kerneloops:

http://www.kerneloops.org/searchweek.php?search=dquot_claim_space

(I think this is a #1 all-time high for a kerneloops count ;)

Pretty sure the 2 commits above can be backported w/o other
dependencies, but maybe Jan & Dmitry can confirm.

I dug into this a little; at least on stock .32 Fedora, it's really
only hitting on a few files, but seems to hit every time they're written:
/var/log/messages, audit.log, etc - things that likely were written
prior to quota being enabled.  Perhaps this is a Fedora initscripts
bug... 

But check this out, with a modified .32 kernel with the above 2 commints,
and a change that reports which inodes were modified:

VFS (sda12): inode(s) 1064 
VFS (sda12): Writes happened before quota was turned on thus quota information is probably inconsistent. Please run quotacheck(8).

# find /etc -inum 1064
/etc/mtab

This sounds a little chicken-and-eggy to me!

Anyway, the above 2 commits should make things -significantly- better,
so w/o any objections, let's get them to -stable.

Thanks,
-Eric
