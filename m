From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Fri, 19 Nov 2010 08:53:25 -0500
Message-ID: <4CE68155.50705@teksavvy.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>	 <20101118130630.GJ6178@parisc-linux.org>	 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>	 <20101118141957.GK6178@parisc-linux.org>	 <20101118142918.GA18510@infradead.org>	 <1290100750.3041.72.camel@mulgrave.site>	 <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com> <1290168976.2570.45.camel@dolmen>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Steven Whitehouse <swhiteho@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:23707 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754120Ab0KSNxa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 08:53:30 -0500
In-Reply-To: <1290168976.2570.45.camel@dolmen>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10-11-19 07:16 AM, Steven Whitehouse wrote:
>
> There doesn't seem to be any technical reason why faster implementations are not possible.

There is a very good reason why faster implementations may be *difficult*
(if not impossible) in many cases:  DETERMINISTIC trim.  This requires
that the drive guarantee the block ranges will return a constant known
value after TRIM.  Which means they MUST write to flash during the trim.
And any WRITE to flash means a potential ERASE operation may be needed.

Simply buffering the trim in RAM and returning success is not an option here,
because loss of power would negate the (virtual) TRIM.  So they MUST record
the trim operation to non-volatile storage.  This can be done in a variety of
ways, but one of the simplest is to just do the full TRIM then and there,
shuffling data and erasing the blocks before signaling completion.

Another, possibly faster way, is to have TRIM just update a block bitmap
somewhere inside FLASH, and avoid ERASE until most of an entire flash block
(eg. 256KB) is marked as "trimmed".  This is the implementation we all hope
for, but which many (most?) current drives do not seem to implement.

Non-deterministic TRIM should also try to ensure that the original data
is no longer there (for security reasons), so it may have the same issues.

> Equally, FITRIM is useful since the overhead can be reduced to certain
> points in time when a system is less busy. With GFS2 (this may well also
> apply to OCFS2) doing a userspace trim is not very easy since there is
> no simple way to access the locking for the fs from userspace

wiper.sh locks the blocks by reserving the space for a file.
But it has to lock ALL freespace, whereas FITRIM could be clever
and only lock the bits it is actually trimming at any instant
(I'm agreeing with you!).

> I'm intending to put a patch together fairly shortly to implement FITRIM for GFS2.

Excellent.  So eventually we might expect FITRIM to reappear at the VFS level,
rather than being buried inside each individual fs's ioctl() handler?

Cheers
