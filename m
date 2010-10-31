From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ext4_lazyinit_thread: 'ret' may be used uninitialized in this
 function
Date: Sun, 31 Oct 2010 18:28:12 +0100 (CET)
Message-ID: <tkrat.ba371a0ea018042b@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57412 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab0JaR2a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 31 Oct 2010 13:28:30 -0400
Content-Disposition: INLINE
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit bfff68738f1c "ext4: add support for lazy inode table
initialization" added the following build warning:

fs/ext4/super.c: In function 'ext4_lazyinit_thread':
fs/ext4/super.c:2702: warning: 'ret' may be used uninitialized in this function

This warning is due to an actual bug.  But I don't know what the fix is.
-- 
Stefan Richter
-=====-==-=- =-=- =====
http://arcgraph.de/sr/

