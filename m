From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
	option
Date: Tue, 12 Jan 2010 11:38:28 -0500
Message-ID: <20100112163828.GA14633@infradead.org>
References: <4B46FCB2.1090308@redhat.com> <4B4B84E2.1050508@redhat.com> <4B4C54DC.4040006@redhat.com> <4B4C6429.6090803@redhat.com> <4B4C67F5.1020009@redhat.com> <20100112122319.GA20596@infradead.org> <4B4C6B70.1050205@redhat.com> <20100112124600.GA7151@infradead.org> <4B4C7297.5030905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Michal Novotny <minovotn@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37389 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab0ALQi3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2010 11:38:29 -0500
Content-Disposition: inline
In-Reply-To: <4B4C7297.5030905@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ok, I looked at the issue.  The problem is that the Xen backend drivers
are (as expected) utterly braindead and submit bios directly from the
virtualization backed without using proper abstractions and thus
bypassing all the cache coherency features in the fileystems (the block
device nodes are just another mini-filesystem in that respect).  So
when you first have buffered access in the host pages may stay in cache
and get overwritten directly on disk by a Xen guest, and once the guest
is down the host may still use the now stale cached data.

I would recommend to migrate your cutomers to KVM which uses the proper
abtractions and thus doesn't have this problem.  There's a reason after
all why all the Xen dom0 mess never got merged to mainline.
