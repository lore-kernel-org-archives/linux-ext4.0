From: Jan Kara <jack@suse.cz>
Subject: Enabling h-trees too early?
Date: Wed, 19 Sep 2007 17:07:15 +0200
Message-ID: <20070919150715.GH9232@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:45743 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751114AbXISOq2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2007 10:46:28 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

  I was just wondering: Currently we start to build h-tree in a directory
already when the size of directory exceeds one block. But honestly, it does
not seem to make much sence to use this feature until the directory is much
larger (I'd say at least 16 or 32 KB). It actually slows down some
operations like deleting the whole directory, etc. So what is the reason
for starting building the tree so early? Just the simplicity of building it
when the directory is just one block large?

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
