From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: ext2fs_dir_iterate2 and ext2_dir_entry
Date: Thu, 2 Sep 2010 22:40:41 +0200
Message-ID: <201009022240.41751.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58434 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932120Ab0IBUko (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Sep 2010 16:40:44 -0400
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.messagingengine.com (Postfix) with ESMTP id 99C78426
	for <linux-ext4@vger.kernel.org>; Thu,  2 Sep 2010 16:40:43 -0400 (EDT)
Received: from bathl.localnet (stgt-4d038e05.pool.mediaWays.net [77.3.142.5])
	by mail.messagingengine.com (Postfix) with ESMTPSA id 51E585E6B6E
	for <linux-ext4@vger.kernel.org>; Thu,  2 Sep 2010 16:40:43 -0400 (EDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We just run the problem that an e2fsck run long in the past converted files 
into directories on a Lustre OST. At least we need to figure out which files 
these are and the old e2fsck logs have been deleted for a long time already. 
(No idea why we run into the problem today again, I guess some files just 
haven't been accessed all the time). Now we could run "find -type d" and look 
for directories where they don't belong to. And for that customer it even will 
work out, as the number of used inodes is low.
But for other customers, with dozens of million files per OST that would be 
too slow. No Lustre already provides a lfsck tool that can restore consistency 
and in principle we could extend it to also check of the object-ID type.
Unfortunately, the database presently does not get this information and the 
main reason for that is that (*func) as argument of ext2fs_dir_iterate2() does 
not take ext2_dir_entry_2, but only ext2_dir_entry without the filetype.

While tracing that down what needs to be done to upgrade it, I'm getting a bit 
lost. 

In ext2fs_dir_iterate2:

ctx.func = func;


then into ext2fs_block_iterate2(, &ctx):

In ext2fs_block_iterate2() the previous &ctx is priv_data and priv_data is 
again added as ctx:

ctx.priv_data = priv_data;


But from there on I don't see where the direntry is ever filled it. Any hints 
would be appreciated.


Thanks,
Bernd



-- 
Bernd Schubert
DataDirect Networks
