From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Fix dirtying of journalled buffers in data=journal mode
Date: Thu,  5 Aug 2010 18:42:14 +0200
Message-ID: <1281026536-10413-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49521 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760334Ab0HEQmy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Aug 2010 12:42:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi,

  this is a second attempt to fix "JBD: Spotted dirty metadata buffer"
warnings from JBD/JBD2. This time I've found a much less hacky fix so
I'm now satisfied. fsx-linux in data=journal mode now runs without warning
for me. Ted, will you merge the ext4 patch, please? I'll merge the ext3 patch
if noone objects...

								Honza
