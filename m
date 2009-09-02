From: Tom Vier <nester@gmail.com>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Wed, 2 Sep 2009 10:48:33 -0400
Message-ID: <20090902144833.GA29651@zero>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com> <20090824133447.GH23677@mit.edu> <20090824183119.GI5931@webber.adilger.int> <20090824201027.GC17684@mit.edu> <4A92F7E0.9010001@redhat.com> <20090824220738.GG17684@mit.edu>
Reply-To: Tom Vier <nester@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f204.google.com ([209.85.216.204]:54726 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbZIBOsr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 10:48:47 -0400
Received: by pxi42 with SMTP id 42so902078pxi.20
        for <linux-ext4@vger.kernel.org>; Wed, 02 Sep 2009 07:48:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20090824220738.GG17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 24, 2009 at 06:07:39PM -0400, Theodore Tso wrote:
> Sure, agreed.  But let's look a bit closer at what "async commit"
> really means.
> 
> What ext3 and ext4 does by default is this:
> 
> 1)  Write data blocks required by data=ordered mode (if any)

Shouldn't there be a write barrier after data blocks, so that the journal
blocks aren't written first? ie, mark the first journal block write with
barrier flag on.

> 2)  Write the journal blocks
> 
> 3)  Wait for the journal blocks to be sent to disk.  (We don't actually
> do a barrier operation), so this just means the blocks have been sent
> to the disk, not necessarily that they are forced to a platter.
> 
> 4)  Write the commit block, with the barrier flag set.
> 
> 5)  Wait for the commit block.

-- 
Tom Vier <nester@gmail.com>
DSA Key ID 0x15741ECE
