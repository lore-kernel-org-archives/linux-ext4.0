From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] ext4: Inode flags handling
Date: Wed,  5 Oct 2016 14:42:53 +0200
Message-ID: <1475671375-22969-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43234 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752041AbcJEMnC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 5 Oct 2016 08:43:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello,

so these two patches implement what I had in mind when discussing ext4
inode flags handling. What do you guys think? I've verified chattr(1)
keeps working as expected xfstests run is still running...

								Honza
