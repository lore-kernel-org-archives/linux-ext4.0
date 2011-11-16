From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Cluster-devel] fallocate vs O_(D)SYNC
Date: Wed, 16 Nov 2011 11:16:12 -0500
Message-ID: <20111116161612.GA17008@infradead.org>
References: <20111116084256.GA22963@infradead.org>
 <1321436588.2713.5.camel@menhir>
 <20111116105413.GA2916@quack.suse.cz>
 <20111116124550.GA11650@infradead.org>
 <20111116133915.GD8195@quack.suse.cz>
 <20111116134234.GA24258@infradead.org>
 <20111116155755.GA22284@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Steven Whitehouse <swhiteho@redhat.com>,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org, cluster-devel@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43445
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755101Ab1KPQQQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Nov 2011 11:16:16 -0500
Content-Disposition: inline
In-Reply-To: <20111116155755.GA22284@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 16, 2011 at 04:57:55PM +0100, Jan Kara wrote:
>   I agree with you that userspace shouldn't have to call fsync. What I
> meant is that sys_fallocate() or do_fallocate() can call
> generic_write_sync(file, pos, len), and that would be completely
> transparent to userspace.

That's different from how everything else in the I/O path works.
If filessystem want to use it, that's fine, but I suspect most could
do it more efficiently.

