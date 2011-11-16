From: Christoph Hellwig <hch@infradead.org>
Subject: fallocate vs O_(D)SYNC
Date: Wed, 16 Nov 2011 03:42:56 -0500
Message-ID: <20111116084256.GA22963@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org, cluster-devel@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41046
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100Ab1KPIm7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Nov 2011 03:42:59 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It seems all filesystems but XFS ignore O_SYNC for fallocate, and never
make sure the size update transaction made it to disk.

Given that a fallocate without FALLOC_FL_KEEP_SIZE very much is a data
operation (it adds new blocks that return zeroes) that seems like a
fairly nasty surprise for O_SYNC users.
