From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger@applied-asynchrony.com>
Subject: Re: xfstests generic/130 hang with non-4k block size ext4 on
 4.7-rc1 kernel
Date: Wed, 8 Jun 2016 14:23:49 +0000 (UTC)
Message-ID: <pan$6abef$45fa540$7a7a0c36$ef55c356@applied-asynchrony.com>
References: <20160531140922.GM5140@eguan.usersys.redhat.com>
	<20160531154017.GC5357@thunk.org>
	<20160601063822.GH10350@eguan.usersys.redhat.com>
	<20160601165800.GI10350@eguan.usersys.redhat.com>
	<20160602085840.GH19636@quack2.suse.cz>
	<20160602121750.GC32574@quack2.suse.cz>
	<20160603101612.GJ10350@eguan.usersys.redhat.com>
	<20160603115844.GB2470@quack2.suse.cz>
	<20160608125631.GA19589@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60431 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbcFHOaG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jun 2016 10:30:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1bAeUe-0004Wo-KE
	for linux-ext4@vger.kernel.org; Wed, 08 Jun 2016 16:30:04 +0200
Received: from pd953e4e5.dip0.t-ipconnect.de ([217.83.228.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 08 Jun 2016 16:30:04 +0200
Received: from holger by pd953e4e5.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 08 Jun 2016 16:30:04 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 08 Jun 2016 14:56:31 +0200, Jan Kara wrote:
(snip)
> Attached patch fixes the issue for me. I'll submit it once a full xfstests
> run finishes for it (which may take a while as our server room is currently
> moving to a different place).
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> From 3a120841a5d9a6c42bf196389467e9e663cf1cf8 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Wed, 8 Jun 2016 10:01:45 +0200
> Subject: [PATCH] ext4: Fix deadlock during page writeback
> 
> Commit 06bd3c36a733 (ext4: fix data exposure after a crash) uncovered a
> deadlock in ext4_writepages() which was previously much harder to hit.
> After this commit xfstest generic/130 reproduces the deadlock on small
> filesystems.

Since you marked this for -stable, just a heads-up that the previous patch
for the data exposure was rejected from -stable (see [1]) because it
has the mismatching "!IS_NOQUOTA(inode) &&" line, which didn't exist
until 4.6. I removed it locally but Greg probably wants an official patch.

So both this and the previous patch need to be submitted.

-h

[1] http://permalink.gmane.org/gmane.linux.kernel.stable/18074{4,5,6}

