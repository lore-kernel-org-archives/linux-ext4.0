From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3 v2] ext4: Inode flags handling
Date: Thu,  6 Oct 2016 13:04:31 +0200
Message-ID: <1475751874-32114-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53645 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752097AbcJFLEi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 6 Oct 2016 07:04:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

so these three patches implement what I had in mind when discussing ext4
inode flags handling. What do you guys think? I've verified chattr(1)
keeps working as expected, xfstests run has passed.

Changes since v1:
* fixed handling of EXTENTS and JOURNAL_DATA flags

								Honza

