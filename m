From: Calvin Owens <jcalvinowens@gmail.com>
Subject: e2fsprogs: Fsck of read-only FS w/ external journal fails after
 1.42.5?
Date: Sat, 4 May 2013 14:53:50 -0500
Message-ID: <20130504195350.GA20046@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gg0-f175.google.com ([209.85.161.175]:56565 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab3EDUTH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 May 2013 16:19:07 -0400
Received: by mail-gg0-f175.google.com with SMTP id k6so430400ggd.20
        for <linux-ext4@vger.kernel.org>; Sat, 04 May 2013 13:19:06 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello all,

Commit a85f8350 (http://goo.gl/aCykm) makes it impossible to fsck an
ext4 filesystem w/ external journal if it is mounted read-only. Certain
distros (Gentoo in my case) expect to be able to do this on the root
filesystem at boot time, and get very upset if they can't.

With journal checks forced now, e2fsck tries to open() the external
journal device, which always fails with -EBUSY if the filesystem is
mounted, read-only or otherwise. Is this the expected behavior? Maybe
the kernel shouldn't be returning an error there? It's been doing so
since at least v3.6.

Clearly this doesn't impact many people, since it's been in the tree for
almost a year now... but I thought I'd mention it.

Thoughts?

Thanks very much,
Calvin
