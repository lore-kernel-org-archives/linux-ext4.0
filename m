From: Jan Kara <jack@suse.cz>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Mon, 17 Dec 2007 18:23:01 +0100
Message-ID: <20071217172301.GL6979@atrey.karlin.mff.cuni.cz>
References: <E1IooC9-0006TJ-Q6@closure.thunk.org> <20071217171135.GB7070@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:38814 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXLQRXD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Dec 2007 12:23:03 -0500
Content-Disposition: inline
In-Reply-To: <20071217171135.GB7070@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Theodore Ts'o (20):
>   Fix errors in test_ss.c so it can be an example application and
>       test case
>   libext2fs: Fix a corner case bug in ext2fs_unlink
  Not that it would matter much but I think this was actually my fix ;).

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
