From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 9483] circular locking dependency detected
Date: Tue, 4 Dec 2007 13:35:15 -0800
Message-ID: <20071204133515.83b26277.akpm@linux-foundation.org>
References: <20071130073446.GA7864@skywalker>
	<20071204212518.GA10020@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43263 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbXLDVlP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2007 16:41:15 -0500
In-Reply-To: <20071204212518.GA10020@elte.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 4 Dec 2007 22:25:18 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > =======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 2.6.24-rc3 #6
> > -------------------------------------------------------
> > bash/2294 is trying to acquire lock:
> > (&journal->j_list_lock){--..}, at: [<c01eee2f>] journal_try_to_free_buffers+0x76/0x10c
> > 
> > but task is already holding lock:
> > (inode_lock){--..}, at: [<c01864b6>] drop_pagecache+0x48/0xd8
> > 
> > which lock already depends on the new lock.
> 
> Andrew, drop_pagecache() is root-only and it has some known deadlock, 
> right?
> 

yup.   It takes inode_lock at too high a level so it can walk the per-sb inode
lists.
