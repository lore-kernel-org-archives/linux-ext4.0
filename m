From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
Date: Wed, 30 Jul 2014 16:56:27 +0900
Message-ID: <53D8A52B.5000006@lge.com>
References: <53CDF437.4090306@lge.com> <20140722073005.GT3935@laptop> <20140722081440.GA5137@thunk.org> <20140727010144.GA13438@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Ts'o <tytso@mit.edu>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
	Minchan Kim <minchan@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140727010144.GA13438@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



2014-07-27 =EC=98=A4=EC=A0=84 10:01, Theodore Ts'o =EC=93=B4 =EA=B8=80:
> Gioh,
>
> As follow up, if you want some further discussions about why these
> patches should be accepted, it would be good to get some hard data
> about why the keeping the ext4 superblock pinned is causing such a
> problem for page migation.  Can you give us more details about what
> the impact is of not having these patches?  And how it compres to
> other data structures which are currently allocated in the moveable
> area and tend to be pinned effectively indefinitely?
>
> Thanks,
>
> 						- Ted
>

I am very sorry to be late. I couldn't access the network for a week.

sb_bread() allocates page from movable area but the reference count of =
the buffer-head
that manages page should be zero to migrate the page.
Therefore brelase() should be called immediately after sb_bread() such =
like fat_fill_super().
But ext4 called brelse() when unmount the superblock.
The page cannot be movable until unmount.
CMA/HOTPLUG memory try to move the page but it fails.

If ext4 needs to keep buffer-cache of superblock until unmount,
it should allocated the page from non-movable area (because it can be a=
 long time).
This patch try to do it.

I also sent an email to Jan Kara. Please refer it.

Thank you for your kindness.
Please inform me if you need any information.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
