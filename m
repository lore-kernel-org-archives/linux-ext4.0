From: Matthias Koenig <mkoenig@suse.de>
Subject: [PATCH 0/3] Move fsck from e2fsprogs to util-linux-ng
Date: Wed, 06 Feb 2008 12:38:59 +0100
Message-ID: <20080206113426.7833.59505.stgit@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:49425 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762294AbYBFLjB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Feb 2008 06:39:01 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here is another attempt to move fsck over to the util-linux-ng
tree. A similar attempt has been done previously by Christoph
Hellwig some time ago.

Patch 1 is the initial move with minor adjustments for the
build system.
Patch 2 adds support for the fsprobe library wrapper.
Patch 3 adds a new option which has been in Suse for some
time to ignore mounted filesystems.

Matthias
