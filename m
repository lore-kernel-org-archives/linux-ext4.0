From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3] JBD checkpointing fixes
Date: Wed, 11 Apr 2012 21:58:35 +0200
Message-ID: <1334174318-11735-1-git-send-email-jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760960Ab2DKT6p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2012 15:58:45 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 172858FD0F
	for <linux-ext4@vger.kernel.org>; Wed, 11 Apr 2012 21:58:44 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi,

  the three patches in this series are a backport of the most important
JBD2 checkpointing fixes that went in recently. Review is welcome, I plan
to push patches to my tree soon.

								Honza
