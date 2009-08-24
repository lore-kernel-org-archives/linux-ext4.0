From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Ext3 improvements to go to Linus
Date: Mon, 24 Aug 2009 16:58:28 +0200
Message-ID: <1251125910-2457-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbZHXO6a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 10:58:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi,

  I plan to send the two following patches to ext3 to Linus tomorrow - the
first one improves the description of the default journaling mode config option
(I'm pushing this mainly because the config option is new in this kernel so I
feel it's better to have a better description from the beginning). The second
one improves the error message when we refuse to change the journaling mode on
remount (see the changelog for why I think it's important).

									Honza
