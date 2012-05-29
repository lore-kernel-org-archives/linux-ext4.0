From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Protect group inode free counting with group
 lock.
Date: Tue, 29 May 2012 08:39:50 -0400
Message-ID: <20120529123950.GC16351@thunk.org>
References: <1337158192-4591-1-git-send-email-tm@tao.ma>
 <4FB3AF00.9060704@redhat.com>
 <4FB3BFC9.20901@tao.ma>
 <4FB3CC8C.4030502@redhat.com>
 <4FB45FBE.10004@tao.ma>
 <20120528222241.GD5610@thunk.org>
 <4FC431E6.7020206@tao.ma>
 <8932CA1F-B08D-4327-AD23-38EA56D49F47@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46216 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab2E2Mjz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2012 08:39:55 -0400
Content-Disposition: inline
In-Reply-To: <8932CA1F-B08D-4327-AD23-38EA56D49F47@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 28, 2012 at 11:57:59PM -0600, Andreas Dilger wrote:
> > We are just disabling the uninit_bg so as to let the block group
> > initialization happen in the mkfs time. I don't know why the checksum is
> > also disabled by ^uninit_bg.
> 
> The checksum is controlled by uninit_bg, because there was a need to
> ensure the bg_itable_unused count and the UNINIT flags could be
> trusted when doing an e2fsck.
> 
> If you don't want to do lazy inode table initialization, that is
> disabled by "mke2fs -E lazy_itable_init=0".

You can also disable whether or not lazy inode table initialization
happens by default via /etc/mke2fs.conf.  At work we have a very
fairly havily modified /etc/mke2fs.conf which has our
production-specific mke2fs parameters defined, so that someone who
runs mke2fs by hand will get the same result at as the automated
systems.

I can easily see how if you are trying for predictable latency
numbers, disabling lazy inode table initialization makes a huge amount
of sense.  I'd recommend doing it via /etc/mke2fs.conf, though.

Regards,

						- Ted

