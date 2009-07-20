From: Ric Wheeler <rwheeler@redhat.com>
Subject: ext3 default journal mode
Date: Sun, 19 Jul 2009 22:50:49 -0400
Message-ID: <4A63DB89.2060306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>,
	"Stephen C. Tweedie" <sct@redhat.com>,
	Eric Sandeen <esa
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53602 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbZGTCvB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Jul 2009 22:51:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Now that we have put some some distance between us and the mega-thread, I think 
that it is time to put some sanity back into the ext3 journal mode options.

My preference is to revert the default back to ordered mode or (if Chris is 
ready) back to guarded mode.

As I mentioned in an earlier email, I think *every* distribution undid this 
default back to ordered mode.

Do any of us who deal in file systems really think that writeback is a 
reasonable default for unsophisticated users or non-FS experts (like those in 
the embedded space) who rely on KCONFIG to get a sense of a debate that they missed?

Failing that, I would like to at very least put sane text in the KCONFIG option.

Something like the following:

diff --git a/fs/ext3/Kconfig b/fs/ext3/Kconfig
index fb3c1a2..4057730 100644
--- a/fs/ext3/Kconfig
+++ b/fs/ext3/Kconfig
@@ -36,16 +36,19 @@ config EXT3_DEFAULTS_TO_ORDERED
           mode, and the journal capability allowed it, ext3 used to
           historically default to 'data=ordered'.

-         That was a rather unfortunate choice, because it leads to all
-         kinds of latency problems, and the 'data=writeback' mode is more
-         appropriate these days.
+         Data ordered mode is the mode used by most distributions, but can
+         introduce latency problems in some workloads, especially if you have
+         a very low latency device.

-         You should probably always answer 'n' here, and if you really
-         want to use 'data=ordered' mode, set it in the filesystem itself
-         with 'tune2fs -o journal_data_ordered'.
+         The current default mode is data writeback mode which favors latency but
+         is more prone to corruption after crashes and power failures and will
+         expose deleted data after a crash to newly allocated files.

-         But if you really want to enable the legacy default, you can do
-         so by answering 'y' to this question.
+         If you have been historically happy with ext3's performance, data ordered
+         mode will be a safe choice and you should answer "y" here.
+
+         If you understand the reliability and data privacy issues of data 
writeback
+         mode and are willing to make that trade off, answer "n".


