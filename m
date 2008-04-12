From: Andi Kleen <andi@firstfloor.org>
Subject: ext3_valid_block_bitmap: Invalid block bitmap in 2.6.25rc in memory
Date: Sat, 12 Apr 2008 22:57:15 +0200
Message-ID: <20080412205714.GA6855@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:2282 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYDLVMb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Apr 2008 17:12:31 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


FYI, a system here running various 2.6.25rc kernels (latest upto rc7-git6) 
with longer uptimes suddenly decided to fsck one of its file systems
due to an error after reboot.

The error causing this was:

kernel: EXT3-fs error (device dm-0): ext3_valid_block_bitmap: Invalid block bitmap - block_group = 285, block = 9338882

detected by the 2.6.25rc7-git6 kernel.

I don't see any ill effects from it and fsck didn't find anything wrong
so it must have been something spurious in memory only (or fsck
fails to check for this condition, but that is hard to imagine) 

The system never showed anything like this on earlier kernel versions.

-Andi
