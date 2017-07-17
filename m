From: Jan Kara <jack@suse.cz>
Subject: Re: More thoughts about xattrs, journal credits, and their location
Date: Mon, 17 Jul 2017 16:42:42 +0200
Message-ID: <20170717144242.GE18199@quack2.suse.cz>
References: <20170706023819.32272-1-tahsin@google.com>
 <20170706023819.32272-2-tahsin@google.com>
 <20170708050900.afuwwia7c4izliir@thunk.org>
 <20170708153048.3lrrcd43ptx5yuy3@thunk.org>
 <CAAeU0aMZjeX6utQfAPa131mhTPK27W4BtWodXYLPT3pss7Tp-w@mail.gmail.com>
 <522BF129-AE45-4722-BCC3-0DDC6A078EB8@dilger.ca>
 <3B21155F-4426-413C-AF16-84E594812530@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tahsin Erdogan <tahsin@google.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41629 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751300AbdGQOmy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Jul 2017 10:42:54 -0400
Content-Disposition: inline
In-Reply-To: <3B21155F-4426-413C-AF16-84E594812530@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 14-07-17 15:13:27, Andreas Dilger wrote:
> >> The downsides of this approach is that it causes the orphan list to be
> >> a bottleneck.  So we would definitely not want to do this all time.
> > 
> > Yes and I think lazy extend/restart should mitigate this.
> 
> Jan had a patch to improve the orphan list performance that never made it
> into the kernel by having a per-CPU orphan list or similar.
> 
> It recall it got hung up on running out of reserved inodes or similar, which
> is an issue we should fix in any case.

Yeah, and I've submitted patches for e2fsprogs to be able to set number of
reserved inodes however they never got merged. I guess I can refresh those
patches and resend if there's interest in the functionality and the
feature...

								Honza


-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
