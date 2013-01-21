From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 7/7 v2] ext4: reclaim extents from extent status tree
Date: Tue, 22 Jan 2013 01:09:37 +0800
Message-ID: <20130121170937.GB15473@gmail.com>
References: <1357901627-3068-1-git-send-email-wenqing.lz@taobao.com>
 <1357901627-3068-8-git-send-email-wenqing.lz@taobao.com>
 <20130118051921.GC13785@thunk.org>
 <20130118053947.GD13785@thunk.org>
 <20130121072443.GA24053@gmail.com>
 <20130121150020.GA5618@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33758 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3AUQzq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jan 2013 11:55:46 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so3405979pbc.5
        for <linux-ext4@vger.kernel.org>; Mon, 21 Jan 2013 08:55:44 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130121150020.GA5618@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 21, 2013 at 10:00:20AM -0500, Theodore Ts'o wrote:
> On Mon, Jan 21, 2013 at 03:24:43PM +0800, Zheng Liu wrote:
> > 
> > Do we need to CC' linux-fsdevel mailling list to let other folks review
> > this patch?
> 
> For this patch, yes.  And we'll need a commit description which
> explains why it's needed.  Since I wrote the patch, I'm happy to
> supply the commit description.  We can include it as a separate patch
> in your patch series, and I'll cc linux-fsdevel.

That would be great if you could give a commit description.

> 
> As Jan mentioned, the only other user of it is Dave Chinner for the
> XFS code, and I had alreday checked to make sure that it shouldn't
> affect him --- but it would be good to cc him so he's in the loop.

As I metioned at another mail, I will cc him.

> 
> Speaking of commit descriptions, I had made some other minor
> adjustments to some of the commits in your last version of the patch
> series, since I had already been assuming that I could take them until
> I saw the potential problems with the memory shrinker patch.  So you
> can just provide a new version of the memory shrinker patch --- or if
> you have other changes you want to make to the earlier patches in that
> patch series, let me know and I can extract out the various comments
> and whitespace fixes that from the patches I have in my private tree,
> so we can merge them with any additional updates to your patches.

Your meaning is that you have made some changes in my patches of extent
status tree, aren't you?  Now I have stashed es_status into es_pblk in
patch 3 (ext4: add physical block and status member into extent status
tree), and added a new patch that removes single extent cache.  I am
happy to merge your changes if you could give them to me.  Please let me
know if I could provide some helps.

Thanks,
                                                - Zheng
