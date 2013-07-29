From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v1 0/5] ext4: Shut down block groups when damage is detected
Date: Mon, 29 Jul 2013 11:28:38 -0400
Message-ID: <x49txjdbd21.fsf@segfault.boston.devel.redhat.com>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
	<20130721143226.GA13473@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab3G2P2n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jul 2013 11:28:43 -0400
In-Reply-To: <20130721143226.GA13473@gmail.com> (Zheng Liu's message of "Sun,
	21 Jul 2013 22:32:26 +0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Zheng Liu <gnehzuil.liu@gmail.com> writes:

> My idea is to let file system can ignore the currurted block.  Namely,
> when we meet a currupted block, we will track it as bad block in bad
> block inode and find another block to save data.  This currupted block
> will never be used.  The first step in my mind is to detect a currpted
> block and mark it as bad block.  After reading the thread and Darrick's
> original patch, I think Darrick's patch is a good start.

I think it's important to call out the exact failure scenario you're
trying to address.  For hard disks, if you get a read error, it can
typically be recovered by re-writing the block.  I imagine this is what
fsck would be doing for metadata repair.  So, I'm not at all sure why
you'd want to track bad blocks in the file system itself.  Could you
elaborate, please?

Cheers,
Jeff
