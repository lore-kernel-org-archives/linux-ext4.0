From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Wed, 29 Jul 2009 12:41:40 -0500
Message-ID: <4A7089D4.3030809@redhat.com>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com> <6601abe90907290910x7cf1122cwac689d1f106326d3@mail.gmail.com> <4A708451.4060908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37065 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZG2Rlo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Jul 2009 13:41:44 -0400
In-Reply-To: <4A708451.4060908@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:

...

> I haven't replied to the first mail yet because I have a lot of
> remembering to do about xfs first, but I'm fairly certain that at least
> your use of blockdev_direct_IO_own_locking() is not correct.  See for
> example all the comments around __blockdev_direct_IO about i_mutex, and
> all the xfs_ilock/xfs_iolock calls in xfs_read/xfs_write.

Oh and i_alloc_sem too, forgot about that one :)

-Eric
