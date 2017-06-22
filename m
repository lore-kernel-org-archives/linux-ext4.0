From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: First stab at ea inode disk format doc updates
Date: Thu, 22 Jun 2017 11:18:56 -0700
Message-ID: <20170622181856.GD4728@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40008 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751193AbdFVSTG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Jun 2017 14:19:06 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I've taken a first stab at capturing the on-disk format updates for ea
inodes.  Let me know about any inaccuracies (though being a wiki, you
can fix them yourself if you're so inclined).

Also -- what is the value of i_mtime (ea inode parent pointer) when the
refcount > 1?

--D

[1] https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout
