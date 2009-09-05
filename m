From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/2] ext4: Automatically enable journal_async_commit on
	ext4 file systems
Date: Sun, 06 Sep 2009 00:57:47 +0200
Message-ID: <20090905225747.GP4197@webber.adilger.int>
References: <1252189963-23868-1-git-send-email-tytso@mit.edu>
 <1252189963-23868-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60229 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbZIEW5t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Sep 2009 18:57:49 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n85MvpIl004373
	for <linux-ext4@vger.kernel.org>; Sat, 5 Sep 2009 15:57:51 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPI00F00T3VAA00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Sat,
 05 Sep 2009 15:57:51 -0700 (PDT)
In-reply-to: <1252189963-23868-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 05, 2009  18:32 -0400, Theodore Ts'o wrote:
> Now that we have cleaned up journal_async_commit, it's safe to enable
> it all the time.  But we only want to do so if ext4-specific INCOMPAT
> features are enabled, since otherwise we will prevent the filesystem
> from being mounted using ext3.

So, the big question is what to do if not-the-last transaction in the
journal has a bad block in it?  This is fairly unlikely, and IMHO the
harm of aborting journal replay too early is likely far outweighed by
the benefit of not "recovering" garbage directly over the filesystem
metadata.

I had thought that you had rejected the e2fsck side of this patch for
that reason, but maybe my memory is faulty...  We still have some
test images for bad journal checksums that you can have if you want.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

