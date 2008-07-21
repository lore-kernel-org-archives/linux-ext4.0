From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup [NEW Version]
Date: Sun, 20 Jul 2008 23:04:02 -0600
Message-ID: <20080721050402.GA3370@webber.adilger.int>
References: <20080715164332.28567.27913.stgit@ichigo>
 <20080715165129.28567.7837.stgit@ichigo> <20080717154604.3fb8e084@ichigo>
 <87r69ro263.fsf@frosties.localdomain> <20080718101518.0722e9e4@gara>
 <873am79d65.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57736 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759990AbYGUFEL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2008 01:04:11 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6L5491e025893
	for <linux-ext4@vger.kernel.org>; Sun, 20 Jul 2008 22:04:10 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4C00H01BCBVZ00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 20 Jul 2008 22:04:09 -0700 (PDT)
In-reply-to: <873am79d65.fsf@frosties.localdomain>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 18, 2008  21:59 +0200, Goswin von Brederlow wrote:
> Won't tune2fs be able to adjust the descriptor size? I thought all the
> keeping compatibility with ext2/3 was so people could upgrade without
> reformating. Or is that maxime broken with 64bit support?

There is definitely compatibility between ext3 and ext4 - you can mount
and use any ext3 filesystem under ext4.  That doesn't mean that ext3
filesystems will have all of the features in ext4 available to them.
Some features like 65000-subdir limit, mballoc, extents will work on
all ext3 filesystems.  Other features like nanosecond timestamps and
fast extended attributes will work on newer ext3 filesystems because
mke2fs was changed to default to 256-byte inodes.

Being able to transparently support 64-bit filesystems was initially
attempted, but proved to be problematic, and the likelihood of
users resizing from < 16TB to > 16TB was decided to be rare enough
that having to do an offline operation to resize the group descriptor
blocks was considered acceptable.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

