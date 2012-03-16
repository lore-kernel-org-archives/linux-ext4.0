From: "George Spelvin" <linux@horizon.com>
Subject: Re: Oops in ext3_block_to_path.isra.40+0x26/0x11b
Date: 16 Mar 2012 05:11:05 -0400
Message-ID: <20120316091105.28264.qmail@science.horizon.com>
References: <20120316085231.GA24821@quack.suse.cz>
Cc: jkosina@suse.cz, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
To: jack@suse.cz, linux@horizon.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:21061 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932509Ab2CPJLH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Mar 2012 05:11:07 -0400
In-Reply-To: <20120316085231.GA24821@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>  Thanks for report!

Thanks for looking at it.

>  Hmm, is any mounting & unmounting happening during your backup?

No, none.  It's a simple BackupPC via rsync.
