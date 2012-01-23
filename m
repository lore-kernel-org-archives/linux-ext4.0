From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ext4 Filesystem recovery ...
Date: Mon, 23 Jan 2012 10:49:20 -0600
Message-ID: <4F1D8F90.3080909@redhat.com>
References: <CAHw_BJ3w84hoeW5-XsNWaRZPp5vB4Jp_ecdQ86iauEw4qHPyFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Paul Richter <iamcomcy@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab2AWQtX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jan 2012 11:49:23 -0500
In-Reply-To: <CAHw_BJ3w84hoeW5-XsNWaRZPp5vB4Jp_ecdQ86iauEw4qHPyFQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/21/12 12:23 AM, Paul Richter wrote:
> Hey guys,
> 
> I am trying to recover 8Tb after a raid failure. RAID issues seem to
> be resolved, but cannot mount the fs,
> 
> dmesg says:
>  EXT4-fs (md127): bad geometry: block count 1953512448 exceeds size of
> device (1953509376 blocks)

Are you sure the md device is set up properly?  It seems to be 3072
shorter than the fs...

> OS sees ext4

What does that mean?

> have complete dd back of fs, so I can kick it around
> 
> debugfs cannot see fs structure.
> 
> fsck tried to fix every inode, but at 500M inodes (and would take a
> month to complete), that far exceeds used inodes
> 
> Am I beating a dead horse here, or is there some hope for recovery?

Off the top of my head, I think maybe your raid is not as happy as you
hope it is...

-Eric

> Thanks in advance,
> 
> Paul
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

