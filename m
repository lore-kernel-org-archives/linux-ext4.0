From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] fs/jbd: set pointer = NULL, after kfree it.
Date: Fri, 04 Jan 2013 09:37:08 +0800
Message-ID: <50E63244.7020706@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:59555 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab3ADBgM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jan 2013 20:36:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


------- Original Message -------
From: Jan Kara <jack@suse.cz>
To: Chen Gang <gang.chen@asianux.com>
Cc: akpm@linux-foundation.org; jack@suse.cz;linux-ext4@vger.kernel.org
Sent: Mon, 31 Dec 2012 16:23:12 +0100
Subject: Re: [PATCH] fs/jbd: set pointer = NULL, after kfree it.

>   The journal structure will get freed immediately after we return from
> journal_init_revoke() (in case it failed) or journal_destroy_revoke() so I
> don't see a point in setting the pointers to NULL. Or do I miss something?

  ok, I can understand.
