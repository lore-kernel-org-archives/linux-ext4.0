From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Incompatibility between mballoc and online resize
Date: Mon, 09 Jun 2008 23:46:00 -0400
Message-ID: <E1K5uo4-0004t4-4d@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org
To: Alex Tomas <alex.tomas@sun.com>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37296 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758746AbYFJDqG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jun 2008 23:46:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've been trying to track down the problems in ext4's online-resizing,
and one of the ones which is most noticeable is that online resizing
mballoc has some specific data structures which need to be enlarged when
the number of block groups in the filesystem are grown dynamically.

Specifically, the s_group_info array; in the current ext4 patch queue,
this isn't happening, which means after the online resizing operation,
when the filesystem is unmounted, ext4_put_super() calls
ext4_mb_release(), which then iterates over s_group_info array, and then
this triggers a kernel oops.

Is clusterfs running with mballoc in production?  If so, how was this
problem fixed?  Did we miss a patch to make sure that on-line resizing
worked with mballoc enabled?

Thanks, regards,

						- Ted
