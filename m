From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] ext4: Fix regression in mount option parsing and a small cleanup
Date: Mon, 16 Apr 2012 14:25:30 +0200
Message-ID: <1334579134-19885-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab2DPMZj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Apr 2012 08:25:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hello,

  this patch series aims at fixing a regression in parsing of journalled quota
mount options introduced by Ted's mount option parsing rewrite. Patches 1 and 2
cleanup the code a bit and patch 3 then fixes the regression. Patch 4 is a tiny
cleanup.

								Honza
