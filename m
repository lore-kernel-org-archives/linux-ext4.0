From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: reserve hole in the migration to non-extent
 based file
Date: Sat, 4 Jul 2015 00:33:29 -0400
Message-ID: <20150704043329.GS9456@thunk.org>
References: <1435942311-2337-1-git-send-email-guaneryu@gmail.com>
 <1435942311-2337-3-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39540 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbbGDEda (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Jul 2015 00:33:30 -0400
Content-Disposition: inline
In-Reply-To: <1435942311-2337-3-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Applied, although I reworded the commit description a little:

ext4: correctly migrate a file with a hole at the beginning

Currently ext4_ind_migrate() doesn't correctly handle a file which
contains a hole at the beginning of the file.  This caused the migration
to be done incorrectly, and then if there is a subsequent following
delayed allocation write to the "hole", this would reclaim the same data
blocks again and results in fs corruption.

...

Thanks!!

					- Ted
