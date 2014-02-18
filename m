From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC][PATCH] ext4: handle fast symlink properly with inline_data
Date: Tue, 18 Feb 2014 11:07:24 -0800
Message-ID: <292627A0-B8C3-4B49-9795-E5DA18462A4B@dilger.ca>
References: <1392275237-6998-1-git-send-email-wenqing.lz@taobao.com> <20140218015231.GF26580@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ian Nartowicz <claws@nartowicz.co.uk>, Tao Ma <tm@tao.ma>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:46656 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaBRTH0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Feb 2014 14:07:26 -0500
Received: by mail-yh0-f50.google.com with SMTP id 29so16036447yhl.9
        for <linux-ext4@vger.kernel.org>; Tue, 18 Feb 2014 11:07:25 -0800 (PST)
In-Reply-To: <20140218015231.GF26580@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I suspect that the stats for symlinks > 60 but < ~150 chars is only a very
small fraction of files. If the code complexity of handling this is very
small (i.e. it is just handled as a natural consequence of writing "data" 
of this size) then I would be OK with it. 

Otherwise, I expect the code and maintenance overhead of supporting
the 0.01% (?) of symlinks that are this size is probably lot worth it. 

People could check what the actual usage is via the "fsstats" tool at:

http://www.pdsi-scidac.org/fsstats/

There is also data there already that reports stats on symlink length, but
it is mostly HPC filesystems and it might be better to redo this with a
desktop-type workload. 

Cheers, Andreas

>> On Feb 17, 2014, at 17:52, Theodore Ts'o <tytso@mit.edu> wrote:
>> 
>> On Thu, Feb 13, 2014 at 03:07:17PM +0800, Zheng Liu wrote:
>> 
>> I am not sure whether or not we need to enable inline_data for a fast
>> symlink inode.  Obviously, it brings a benefit that after enabling
>> inline_data feature for a fast symlink we can get more space to store
>> the path.  But it seems that the original patch doesn't want to do this
>> Another solution for fixing this bug is to disable inline_data for a
>> fast symlink.  Any comment?
> 
> Well, if we are using inline data, and we have a symlink which is
> longer than 60 bytes, but less than extra space available for an
> inline data, it seems like a good thing to support.
> 
> The downside is that it is a bit more complication to add the kernel's
> code in both the kernel as well as e2fsprogs, but it doesn't seem that
> bad.
> 
> So I don't have any objections to adding this functionality.  What do
> other folks think?
> 
>                       - Ted
