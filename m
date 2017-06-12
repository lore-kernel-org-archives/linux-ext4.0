From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH] fs: ext4: don't trap kswapd and allocating tasks on
 ext4 inode IO
Date: Mon, 12 Jun 2017 17:51:50 -0400
Message-ID: <20170612215150.GA17505@cmpxchg.org>
References: <20170515154634.19733-1-hannes@cmpxchg.org>
 <20170516143645.GA7316@quack2.suse.cz>
 <20170516154105.GA22633@cmpxchg.org>
 <20170516160337.GD7316@quack2.suse.cz>
 <20170612080957.GA22728@quack2.suse.cz>
 <20170612143727.GA1198@cmpxchg.org>
 <20170612151934.GA3930@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170612151934.GA3930@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 12, 2017 at 05:19:34PM +0200, Jan Kara wrote:
> On Mon 12-06-17 10:37:27, Johannes Weiner wrote:
> > However, with or without a reproducer, it seems to make sense to not
> > serialize evict() on commits when we don't have to from a correctness
> > point of view. Would you be opposed to just merging the patch anyway?
> 
> No, I guess the patch makes sense even without a reproducer. I'll send it
> to Ted for inclusion.

Thank you, I appreciate it!
