From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: new block group bitmaps not being initialized after resize!?
Date: Thu, 10 Jan 2013 22:07:11 -0200
Message-ID: <20130111000711.GA2490@andromeda.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab3AKAHS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Jan 2013 19:07:18 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0B07IvD025785
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2013 19:07:18 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi guys,

I'm working on a Fedora bugzilla (https://bugzilla.redhat.com/show_bug.cgi?id=852833)
together with Eric and we found that the problem described on the bugzilla
happens when the commit 93f9052643 is not applied, which is the case of the
Fedora 16 kernel being discussed there.

Although we already found the solution to the problem in the commit above,
looking through the commit have raised some questions regarding to the bitmap of
the newer block groups added to the FS after it is extended.

The newer block groups do not have flags ITABLE_ZEROED and INODE_UNINIT set,
even when 'lazy_itable_init' is enabled.

Without this commit, inode stale data might be exposed and also makes fsck
complain about all inodes of the newer block groups.

The question is, are these flags expected to not be found on these newer block
groups or they should be set?

The lack of these flags on newer block groups is an expected behaviour or is
something that should be fixed?

FWIW, in the old ext4_group_add(), we added EXT4_BG_INODE_ZEROED flag to the
bg_flags, also, I did some tests here and the lack of these flags look to not be
affecting filesystem integrity, i.e. new inodes can be properly allocated, which
sounds that these uninitialized inodes/bitmaps are set to be initialized as soon
as a first inode is allocated on these new BGs.


Anything else I'm missing Eric?

Cheers,
-- 
Carlos
