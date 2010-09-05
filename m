From: David Rientjes <rientjes@google.com>
Subject: Re: [patch v2 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Sun, 5 Sep 2010 16:03:52 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1009051602130.5003@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <alpine.DEB.2.00.1009011757360.24694@chino.kir.corp.google.com> <4C7F5951.6040809@gmail.com> <20100902145141.GA3273@quack.suse.cz> <20100903071506.6e6b4d63@notabene>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Kara <jack@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
	cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
	reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:18830 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab0IEXEF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Sep 2010 19:04:05 -0400
In-Reply-To: <20100903071506.6e6b4d63@notabene>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 3 Sep 2010, Neil Brown wrote:

> I'm actually a bit confused about this too.
> I thought David said he was removing a branch on the *slow* path - which make
> sense as you wouldn't even test NOFAIL until you had a failure.
> Why are branches on the slow-path an issue??

They aren't necessarily an issue in the performance sense, this is a 
cleanup series since all converted callers to using these new functions 
(and the eventual removal of __GFP_NOFAIL entirely) are using the bit 
unnecessarily since they all have orders that implicitly loop in the page 
allocator forever already, with or without the flag.
