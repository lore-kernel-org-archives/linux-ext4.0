From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 4/6] jbd: remove dependency on __GFP_NOFAIL
Date: Mon, 23 Aug 2010 12:28:13 -0700
Message-ID: <20100823122813.1ffa3f2e.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1008161956190.17924@chino.kir.corp.google.com>
	<20100817095103.GA3557@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: David Rientjes <rientjes@google.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825Ab0HWT2W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Aug 2010 15:28:22 -0400
In-Reply-To: <20100817095103.GA3557@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 17 Aug 2010 11:51:03 +0200
Jan Kara <jack@suse.cz> wrote:

> On Mon 16-08-10 19:58:01, David Rientjes wrote:
> > Removes the dependency on __GFP_NOFAIL by looping indefinitely in the
> > caller.
> > 
> > The error handling when kzalloc() returns NULL in start_this_handle()
> > was removed since it was unreachable.
>   Thanks! I've added the patch to my tree.

Please unadd it.  JBD should be fixed so that it can appropriately
handle out-of-memory conditions.  Until that time we shouldn't hide its
shortcomings with this open-coded equivalent.

