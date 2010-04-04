From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: add rb_tree cache to struct ext4_group_info
Date: Sun, 4 Apr 2010 14:26:01 +0800
Message-ID: <h2kac8f92701004032326v22750abfr458ea51bbfc0b901@mail.gmail.com>
References: <h2tac8f92701003280211p70c2dbcpac77b16fb27deb79@mail.gmail.com>
	 <x2tac8f92701003310726uf41823efz3d2ef98f438872b6@mail.gmail.com>
	 <20100403153413.GO8298@thunk.org>
	 <p2xac8f92701004031826ice3889f1tc27211ac145de4fd@mail.gmail.com>
	 <20100404020656.GC18524@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.211.172]:52947 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab0DDG0D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Apr 2010 02:26:03 -0400
Received: by ywh2 with SMTP id 2so2011984ywh.33
        for <linux-ext4@vger.kernel.org>; Sat, 03 Apr 2010 23:26:01 -0700 (PDT)
In-Reply-To: <20100404020656.GC18524@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/4/4, tytso@mit.edu <tytso@mit.edu>:
> On Sun, Apr 04, 2010 at 09:26:26AM +0800, jing zhang wrote:
>> > That being said, I'm not convinced ext4_mb_generate_from_freelist() is
>> > (a) necessary, or (b) bug-free, either.  The whole point of having
>> > extents in bb_free_root tree is that those extents aren't safe to be
>> > placed in the buddy bitmap.  And ext4_mb_generate_from_freelist()
>> > isn't freeing the nodes from the rbtree.  Fortunately it looks like
>> > ext4_mb_generate_from_freelist is only getting called when the buddy
>> > bitmap is being set up, so the rbtree should be empty during those
>> > times.
>> >
>> > I need to do some more investigation, but I think the function can be
>> > removed entirely.
>>
>> Do you mean that ext4_mb_generate_from_freelist() can be removed entirely?
>
> Maybe.  I need to do more investigation to be sure.  The code in
> mballoc is subtle, and in some places there is stuff which is vestigal
> or misnamed, but it means that I'm going to be very careful before
> changing things.
>
> It also means that if you submit patches, you need to be very clear
> what you think the surrounding code is doing, why you think it's
> wrong, and how your patch make things better.  For example, this:
>
>     The function, ext4_mb_discard_group_preallocations(), works alone as
>     hard as possible without correct understanding its caller's good
>     thinking.
>
>     And now try to relieve it in simple way.
>
> is almost useless as a comment.  It doesn't help me understand the
> code.  "hard as possible"?  Huh?  "without correct understanding"?
> How can code, unless it's artificially intelligent, have
> understanding?  And if you meant the original author had no
> understanding, how do you know that?  "caller's good thinking"?  Same
> question; the calling code doesn't think.
>
> This sort of explanation isn't helpful in understanding the patch.
>
> 							- Ted
>

Another good lesson, I got it.

Thanks
              - zj
