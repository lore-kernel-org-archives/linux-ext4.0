From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
Date: Thu, 31 Jul 2014 08:45:57 +0900
Message-ID: <53D983B5.3020903@lge.com>
References: <53CDF437.4090306@lge.com> <20140722073005.GT3935@laptop> <20140722093838.GA22331@quack.suse.cz> <53D8A258.7010904@lge.com> <20140730101143.GB19205@quack.suse.cz> <20140730101920.GI19379@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
 linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>,
 Joonsoo Kim <js1304@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140730101920.GI19379@twins.programming.kicks-ass.net>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org



2014-07-30 =EC=98=A4=ED=9B=84 7:19, Peter Zijlstra =EC=93=B4 =EA=B8=80:
> On Wed, Jul 30, 2014 at 12:11:43PM +0200, Jan Kara wrote:
>>> sb_bread allocates page from movable area but it is not movable until=
 the
>>> reference counter of the buffer-head becomes zero.
>>> There is no lock for the buffer but the reference counter acts like l=
ock.
>>    OK, but why do you care about a single page (of at most handful if =
you
>> have more filesystems) which isn't movable? That shouldn't make a big
>> difference to compaction...
>
> The thing is, CMA _must_ be able to clear all the pages in its range,
> otherwise its broken.
>
> So placing nonmovable pages in a movable block utterly wrecks that.

YES. Even a single page can make CMA migration fail.

>
> Now, Ted said that there's more effectively pinned stuff from
> filesystems (and I imagine those would be things like the root inode
> etc.) and those would equally wreck this..
>
> But Gioh didn't mention any of that.. he should I suppose.

Thanks to inform me.

I thought there are more pinned stuff but I didn't know what they are.
I tried CMA migration but it failed even after I moved the sb page-cache =
to non-movable area.
So I just guessed there are more pinned stuff.
I am newbie and not familiar with filesystem code.

Of course all of the pinned stuff should be moved to non-movable area.

>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
