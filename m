From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: Uninitialized extent races
Date: Fri, 21 Dec 2012 16:34:33 +0400
Message-ID: <87bodnh9d2.fsf@openvz.org>
References: <20121221012526.GD13474@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:35917 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2LUMl4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Dec 2012 07:41:56 -0500
Received: by mail-la0-f51.google.com with SMTP id e4so5009778lag.38
        for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2012 04:41:52 -0800 (PST)
In-Reply-To: <20121221012526.GD13474@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 21 Dec 2012 02:25:26 +0100, Jan Kara <jack@suse.cz> wrote:
>   Hello,
> 
>   I was looking into handling of unwritten extents and I've noticed two
> things:
> 1) Commit 60d4616f added ext4_flush_unwritten_io() call into
>    ext4_fallocate() with a comment that it should avoid a race between
>    AIO DIO and fallocate. But that really doesn't completely fix the issue
>    because writeback can create unwritten extents as well and that is not
>    synchronized with i_mutex unlike AIO DIO.
> 
> 2) Commit dee1f973 actually changed ext4_convert_unwritten_extents_endio()
>    to be able to deal with the situation when extent we want to convert
>    isn't exactly the one in the extent tree (i.e., it was merged with
>    another extent in the mean time). That was the situation 1) tried to
>    prevent so it seems to make ext4_flush_unwritten_io() call from 1)
>    unnecessary?
In fact first patch is still required because dee1f973 may result in
in-depth tree grow so ENOSPC is not unprobable which result in 
complain from ext4_end_io().
> 
> Am I missing something Dmitry? Also I was wondering about one thing: Does
> anybody see a problem with disabling merging of uninitialized extents
> completely?
Yeah, actually this is sound idea. Instead of fighting again weird races
it is reasonable to just prevent it, because merge uninitialized extents
is false optimization anyway. Later it will be merged after if extents
becomes initialized(which is right place for optimization).
> It would simplify the code (end_io conversion doesn't need to
> potentially split extents) and the case when we really want to merge
> extents - i.e., when someone calls fallocate() on small chunks - doesn't
> seem like the case we need to optimize for? Also it would bound the amount of
> transaction credits we need for conversion to 1 block which would make it
> easier for me to change ext4 to clear PageWriteback only after extent
> conversion is done (again code simplification, more uniform handling of
> page writeback).
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
