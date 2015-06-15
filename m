From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix race between truncate and
 __ext4_journalled_writepage()
Date: Mon, 15 Jun 2015 15:37:55 -0400
Message-ID: <20150615193755.GE5003@thunk.org>
References: <20150615011433.GA15793@thunk.org>
 <1434331430-23125-1-git-send-email-tytso@mit.edu>
 <20150615123352.GD4368@quack.suse.cz>
 <20150615130611.GJ15793@thunk.org>
 <20150615170325.GA2381@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	enwlinux@gmail.com, stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150615170325.GA2381@quack.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 15, 2015 at 07:03:25PM +0200, Jan Kara wrote:
>   I think that fully switching lock ordering for data=journal mode back to
> page lock -> transaction start (which is what you effectively do when you
> never drop page lock in ->writepage) is rather error prone. We'd have to be
> careful to avoid lock inversion also for places like ->write_begin,
> ->releasepage, ->invalidatepage etc. For example ext4_write_begin() will
> currently call lock_page() with transaction started which could deadlock
> against journalled writepage you suggest. So effectively we'd have to
> completely separate aops for data=journal mode. Doable but I'm not sure
> it's worth it.

Good point.  OTOH, things are kind of fragile with respect to
ext4_write_begin() in data=journal mode, as you've pointed out.  But
it's not causing any problems as far as we know, so so I'll use the
patch which you ack'ed and maybe later on, we can figure out a better
way to clean this up.

Thanks,

						- Ted
