From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug 9483] circular locking dependency detected
Date: Tue, 4 Dec 2007 22:25:18 +0100
Message-ID: <20071204212518.GA10020@elte.hu>
References: <20071130073446.GA7864@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	bugme-daemon@bugzilla.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:39699 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbXLDV0E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2007 16:26:04 -0500
Content-Disposition: inline
In-Reply-To: <20071130073446.GA7864@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> wrote:

> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.24-rc3 #6
> -------------------------------------------------------
> bash/2294 is trying to acquire lock:
> (&journal->j_list_lock){--..}, at: [<c01eee2f>] journal_try_to_free_buffers+0x76/0x10c
> 
> but task is already holding lock:
> (inode_lock){--..}, at: [<c01864b6>] drop_pagecache+0x48/0xd8
> 
> which lock already depends on the new lock.

Andrew, drop_pagecache() is root-only and it has some known deadlock, 
right?

	Ingo
