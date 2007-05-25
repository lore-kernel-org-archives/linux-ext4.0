From: Jim Garlick <garlick@llnl.gov>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Fri, 25 May 2007 12:31:02 -0700 (PDT)
Message-ID: <Pine.LNX.4.61.0705251215220.17095@nine>
References: <1179777153.3910.13.camel@garfield> <20070525143957.GA12669@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-1.llnl.gov ([128.115.41.81]:42715 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbXEYTf0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 May 2007 15:35:26 -0400
In-Reply-To: <20070525143957.GA12669@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

For what it's worth, we have several petabytes of data residing in
ext3 file systems, a large staff of mainly non-idiots, and HA s/w,
and I still feel strongly that multi-mount protection is a good idea.
People, software, and hardware all malfunction in myriad ways, and the 
more you have, the greater the odds (or so it seems to us).  This 
relatively simple safeguard at the fs level has high value IMHO.

Regards,

Jim

On Fri, 25 May 2007, Theodore Tso wrote:

> Hi Kalpak,
>
> On Tue, May 22, 2007 at 01:22:32AM +0530, Kalpak Shah wrote:
>> It will also protect against running e2fsck on a mounted filesystem
>> by adding similar logic to ext2fs_open().
>
> Your patch didn't add this logic to ext2fs_open(); it just reserved
> the space in the superblock.
>
> I don't mind reserving the space so we don't have to worry about
> conflicting superblock uses, but I'm still on the fence about actually
> adding this functionality (a) into e2fsprogs, and (b) into the ext4
> kernel code.  I guess it depends on how complicated/icky the
> implementation code is, I guess.  The question as before is whether
> the complexity is worth it, given that someone who is actually going
> to be subject to accidentally mounting an ext3/4 filesystem on
> multiple systems needs to be using an HA system anyway.  So basically
> this is just to protect against (a) a bug/failure in the HA subsystem,
> and (b) the idiotic user that failed to realized he/she needed to set
> up an HA subsystem in the first place.  Granted, the universe is going
> to create idiots at a faster rate that we can deal with it, but that's
> why I'm still not 100% convinced the complexity is worth it.
>
> To be fair, if I was on a L3 support team having to deal with these
> idiots, I'd probably feel differently.  :-)
>
> 							- Ted
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
