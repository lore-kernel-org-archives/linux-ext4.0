From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Thu, 3 Feb 2011 19:04:31 -0500
Message-ID: <20110204000431.GB2623@thunk.org>
References: <20110203144011.GA28409@quack.suse.cz>
 <4D4AC4E2.701@redhat.com>
 <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50692 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1BDAEr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Feb 2011 19:04:47 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 03, 2011 at 11:32:01AM -0800, Michael Rubin wrote:
> On Thu, Feb 3, 2011 at 7:08 AM, Eric Sandeen <sandeen@redhat.com> wro=
te:
> > If we can have a real plan for moving in this direction though, I'd
> > support it. =A0I'm just not sure how we get enough real testing und=
er
> > our belts to be comfortable with dropping ext[23], especially as
> > most distros now default to ext4 anyway.
>=20
> Eric what sort of testing are you looking for?

The biggest problem in my opinion is that we have a large set of
options, and we don't necessarily test all of them.  The options that
I normaly test is

   * 4k blocksize, with journal, extents
   * 1k blocksize, with journal, extents (this helps flush out problems
		   that show up architectures with 16k page size and
		   4k block sizes, i.e., Power PC and Itanium)
   * 4k blocksize, no journal

Things that I should also test, but which take a lot longer:

   * nodelalloc (and combinatorics, 4k/1k blocksize, journal)
   * filesystem with extents disabled (with more combinatorics!)

I'll sometimes do these additional tests, but they're not part of my
regular test sets.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
