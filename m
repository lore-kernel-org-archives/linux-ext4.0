From: Theodore Ts'o <tytso@mit.edu>
Subject: e2fsprogs: Patches to resize2fs
Date: Tue, 17 Jun 2008 02:06:29 -0400
Message-ID: <1213682792-4878-1-git-send-email-tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:33397 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751792AbYFQGGe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2008 02:06:34 -0400
Received: from root (helo=closure.thunk.org)
	by thunker.thunk.org with local-esmtp   (Exim 4.50 #1 (Debian))
	id 1K8UKu-0005H5-QO
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 02:06:32 -0400
Received: from tytso by closure.thunk.org with local (Exim 4.67)
	(envelope-from <tytso@mit.edu>)
	id 1K8UKu-0001Ib-6M
	for linux-ext4@vger.kernel.org; Tue, 17 Jun 2008 02:06:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following patches fix resize2fs support for uninit_bg filesystems,
as well as a rather embarassing bug which I had introduced while
making mke2fs -j more efficient.  The final patch prohibits resizing
filesystems that have flex_bg enabled and do not have the resize_inode
feature enabled, since my testing has found a nasty bug in the flex_bg
&& !resize_inode case, and I fix isn't going to be coming right away.

In any case, this should make e2fsprogs work much better; at this
point resizing should be in good shape except for:

1)  flex_bg with on-line resizing

and

2)  flex_bg && !resize_inode with off-line resizing.

There may also be problems with flex_bg && uninit_bg; more testing is
needed there to be 100% sure there's nothing hiding in that particular
feature set combination.

						- Ted


