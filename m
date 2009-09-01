From: "George Spelvin" <linux@horizon.com>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
Date: 1 Sep 2009 07:18:03 -0400
Message-ID: <20090901111803.11027.qmail@science.horizon.com>
References: <4a2c5faeb04cab59af9ba6ab512c9916.squirrel@neil.brown.name>
Cc: david@lang.hm, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	pavel@ucw.cz
To: linux@horizon.com, neilb@suse.de
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <4a2c5faeb04cab59af9ba6ab512c9916.squirrel@neil.brown.name>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>> An embedded checksum, no matter how good, can't tell you if
>> the data is stale; you need a way to distinguish versions in the pointer.

> I would disagree with that.
> If the embedded checksum is a function of both the data and the address
> of the data (in whatever address space seems most appropriate) then it can
> still verify that the data found with the checksum is the data that was
> expected.
> And storing the checksum with the data (where it is practical) means
> index blocks can be more dense so on average fewer accesses to storage
> are needed.

I must not have been clear.  Originally, block 100 has contents version 1.
This includes a correctly computed checksum.

Then you write version 2 of the data there.  But there's a bit error in
the address and the write goes to block 256+100 = 356.  So block
100 still has the version 1 contents, complete with valid checksum.
(Yes, block 356 is now corrupted, but perhaps it's not even allocated.)

Then we go to read block 100, find a valid checksum, and return incorrect
data.  Namely, version 1 data, when we expact and want version 2.

Basically, the pointer has to say which *version* of the data it points to,
not just the block address.  Otherwise, it can't detect a missing write.

If density is a big issue, then including a small version field is a
possibility.
