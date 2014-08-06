From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
Date: Wed, 06 Aug 2014 15:15:17 +0900
Message-ID: <53E1C7F5.7040901@lge.com>
References: <20140730101143.GB19205@quack.suse.cz> <53D985C0.3070300@lge.com> <20140731000355.GB25362@quack.suse.cz> <53D98FBB.6060700@lge.com> <20140731122114.GA5240@quack.suse.cz> <53DADA2F.1020404@lge.com> <53DAE820.7050508@lge.com> <20140801095700.GB27281@quack.suse.cz> <20140801133618.GJ19379@twins.programming.kicks-ass.net> <20140801152459.GA7525@quack.suse.cz> <20140801160415.GD9918@twins.programming.kicks-ass.net>
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
In-Reply-To: <20140801160415.GD9918@twins.programming.kicks-ass.net>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org



2014-08-02 =EC=98=A4=EC=A0=84 1:04, Peter Zijlstra =EC=93=B4 =EA=B8=80:
> On Fri, Aug 01, 2014 at 05:24:59PM +0200, Jan Kara wrote:
>
>>    OK, makes sense. But then if there's heavy IO going on, anything th=
at has
>> IO pending on it is pinned and IO completion can easily take something
>> close to a second or more. So meeting subsecond deadlines may be tough=
 even
>> for ordinary data pages under heavy load, even more so for metadata wh=
ere
>> there are further constraints. OTOH phones aren't usually IO bound so =
in
>> practice it needn't be so bad ;).
>
> Yeah, typically phones are not IO bound :-)
>
>> So if it is sub-second unless someone
>> loads the storage, then that sounds doable even for metadata. But we'l=
l
>> need to attach ->migratepage callback to blkdev pages and at least in =
ext4
>> case teach it how to move pages tracked by the journal.
>
> Right, making it possible at all if of course much prefered over not
> possible, regardless of timeliness :-)
>
>>> Sadly its not only mobile devices that excel in crappy hardware, ther=
e's
>>> plenty desktop stuff that could use this too, like some of the v4l
>>> devices iirc.
>>    Yeah, but in such usecases the guarantees we can offer for completi=
on of
>> migration are even more vague :(.
>
> Yeah, lets start by making it possible, after that we can maybe look at
> making it better, who knows.
>

Is my patch applicable? Or what do I have to do now?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
