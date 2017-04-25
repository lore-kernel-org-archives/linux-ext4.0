From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 5/6] f2fs: switch to using
	fscrypt_match_name()
Date: Tue, 25 Apr 2017 21:22:16 +0200
Message-ID: <7b3931c1-dfc5-6e30-d950-204c4a9f480c@nod.at>
References: <20170424170013.85175-1-ebiggers3@gmail.com>
	<20170424170013.85175-6-ebiggers3@gmail.com>
	<CAFLxGvxdanXJhzioJmgvr3mzSkS=Bxfh1bbtAn1L+t6CoSaHcA@mail.gmail.com>
	<20170425174632.GA41477@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Gwendal Grignou <gwendal@chromium.org>, "Theodore Y . Ts'o" <tytso@mit.edu>,
	Eric Biggers <ebiggers@google.com>, David Gstir <david@sigma-star.at>,
	linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Ryo Hashimoto <hashimoto@chromium.org>,
	linux-ext4@vger.kernel.org, Kazuhiro Inaba <kinaba@chromium.org>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20170425174632.GA41477@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Eric,

Am 25.04.2017 um 19:46 schrieb Eric Biggers:
>> Sorry if this is a stupid question, but why do you have to compare hashes _and_
>> the last few bytes of the bigname?
>> A lookup via bigname gives you two 32bits hash values, and there I'd assume that
>> this is sufficient for a collisions free lookup. Especially since an
>> resumed readdir()
>> with a 64bits cookie has to work too on your filesystem.
>>
> 
> Well, the problem is that hashes may not be sufficient to uniquely identify a
> name in all cases.  f2fs uses only a 32-bit hash so it's trivial to create
> collisions on it, as I demonstrated.  Even collisions of two 32-bit hashes, as
> used by ext4 and ubifs, are possible.  And ext4 currently doesn't even compare
> the hashes during directory searches, beyond using them to find the correct
> directory block, since the hashes aren't stored in the directory entries.

I agree that finding a collision in a 32bits hash is easy, but for 64bits it
is *much* harder.

> Could this mean that telldir()/seekdir() is unreliable too, probably.  But for
> lookups of the "digested" names we aren't limited to just the 64-bit readdir
> position, so we can avoid duplicating the bug.  Also, collisions in the digested
> names are very problematic since they result in undeletable files, rather than
> just poor performance and broken telldir()/seekdir().

True.
Let me think whether we can add such a check to UBIFS.

Thanks,
//richard

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
