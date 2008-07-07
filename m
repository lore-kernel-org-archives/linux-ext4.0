From: Andreas Dilger <adilger@sun.com>
Subject: Re: error in ext4_mb_release_inode_pa
Date: Mon, 07 Jul 2008 17:20:22 -0600
Message-ID: <20080707232022.GX6239@webber.adilger.int>
References: <48723646.1050101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64291 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbYGGXUZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jul 2008 19:20:25 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m67NKO47011005
	for <linux-ext4@vger.kernel.org>; Mon, 7 Jul 2008 16:20:24 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K3N00101SP91V00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 07 Jul 2008 16:20:24 -0700 (PDT)
In-reply-to: <48723646.1050101@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 07, 2008  10:29 -0500, Eric Sandeen wrote:
> This was on #linuxfs last night, and I think I've seen at least one
> other report of it:
> 
> [22:44]  <shehjart> any ideas why i get the following two lines on the
> serial console when writing to ext4 over software raid0:
> [22:44]  <shehjart> pa e00001004112d450: logic 11928, phys. 47003288,
> len 360
> [22:45]  <shehjart> EXT4-fs error (device md0):
> ext4_mb_release_inode_pa: free 176, pa_free 174

The bug that I recalled from Lustre is unlikely to be the same.  It is
https://bugzilla.lustre.org/show_bug.cgi?id=15932

	"error: N blocks in bitmap, M in gd"

There was a second bug in ext3_mb_use_best_found() hit on > 8TB filesystems:
https://bugzilla.lustre.org/show_bug.cgi?id=16101

	BUG_ON(ac->ac_b_ex.fe_group != e3b->bd_group);


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

