From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Q] ext3 mkfs: zeroing journal blocks
Date: Mon, 11 May 2009 12:58:59 -0500
Message-ID: <4A086763.9090907@redhat.com>
References: <71a0d6ff0905110803t1a6b34ccq91d5494f95fe1f34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Alexander Shishkin <alexander.shishckin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38089 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZEKR7A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 13:59:00 -0400
In-Reply-To: <71a0d6ff0905110803t1a6b34ccq91d5494f95fe1f34@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Alexander Shishkin wrote:
> Hi,
> 
> Here's a question regarding ext3, jbd and mkfs. I'm not 100%
> confident this is the right list, got it from MAINTAINERS for ext3
> and jbd. Please correct me if this is wrong.
> 
> As far as I could tell from brief looking at jbd code, it seemed to
> me that the only thing that has to be reset during the filesystem
> creation time is journal superblock (talking about the default case
> when journal resides within an ext3 partition). However, currently 
> mke2fs -j would zero every journal block no matter what. So, the 
> question is: can this zeroing really be avoided in mkfs? I tried
> commenting-out ext2fs_zero_block() in mkjournal_proc() and it seems
> to speed up mkfs a great deal while the kernel is still able to mount
> the partition afterwards. Also, for the sake of experiment, I filled
> the partition with urandom's contents before doing the modified mkfs
> and it still works. My next step in this direction would be to go 
> through jbd code, but before doing that, I thought, I'd ask here.
> 
> Please CC me in replies as I'm not (yet) subscribed.
> 
> Regards,

Hi Alexander -

Yes, this is a fine list for these questions.

Looks like commit 16ed5b3af43c72f60991222b9d7ab65cf53f203d added the
block zeroing at the same time as external journal support went in way
back in 2001 ... IOW, it wasn't added later to fix anything in
particular.  Also even at that time, internal journals were not zeroed,
so it's not like that was removed in the meantime.  Seems extraneous to
me, but ... maybe Ted knows more ...

-Eric
