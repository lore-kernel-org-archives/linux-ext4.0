From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: suspiciously good fsck times?
Date: Thu, 10 Jul 2008 16:13:37 -0400
Message-ID: <48766D71.7050100@gmail.com>
References: <20080710172829.GF10402@mit.edu> <20080710175354.GA3447@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.233]:65206 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYGJUNm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2008 16:13:42 -0400
Received: by wx-out-0506.google.com with SMTP id h29so1509661wxd.4
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 13:13:40 -0700 (PDT)
In-Reply-To: <20080710175354.GA3447@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> Based on the graphs which Eric posted, One interesting thing I think
> you'll find if you repeat the ext3 experiment with e2fsck -t -t is
> that pass2 will be about seven times longer than pass1.  (Which is
> backwards from most e2fsck runs, where pass2 is about half pass 1's
> run time --- although obviously that depends on how many directory
> blocks you have.)
>
>   
Pass2 was where both spent most of their time, but I can rerun later to 
validate that.

> Yes, some kind of reservation windows would help on ext3 --- but the
> question is whether such a change would be too-specific for this
> benchmark or not.  Most of the time directories don't grow to such a
> huge size.  So if you use a smallish (around 8 blocks, say) for many
> directories this might lead to more filesystem fragmentation that in
> the long run would cause the filesystem not to age well; it also
> wouldn't help much when you have over 11 million files in the
> directory, and a directory with over 100,000 blocks.
>   
I think that the key is to lay out the directories (or files for that 
matter) in reasonably contiguous chunks.  If we could always bump up the 
allocation by enough to capture a full disk track (128k? 512k?) you 
would probably be near optimal, but any significant portion of a track 
would also help.

It would be interesting to rerun with the 46 million files in one 
directory as well (basically, for working sets that have no natural 
mapping into directories like some object based workloads).

> I don't think delayed allocation is what's helping here either,
> because the journal will force the directory blocks to be placed as
> soon as we commit a transaction.  I think what's saving us here is
> that flex_bg and mballoc is separating the directory blocks from the
> data blocks, allowng the directory blocks to be closely packed
> together.
>
> 					- Ted
>   
I can try to validate that, thanks!

ric


