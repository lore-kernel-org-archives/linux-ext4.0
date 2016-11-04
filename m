From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] A proposal for adding case insensitive lookups to ext4
Date: Fri, 4 Nov 2016 17:12:53 -0600
Message-ID: <EC4AEE18-ABB3-43C3-AD8B-BF2E1D72A1AC@dilger.ca>
References: <20161103172842.q7avc7rztny3zndd@thunk.org> <E33408BD-68CC-49E4-9B32-EC06DB057509@dilger.ca> <20161104215105.waabpcf7zganrdbr@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_C6328369-F27B-4031-BB14-104BEC59B7B7"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, guy@linux.com,
        jra@google.com, drosen@google.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36739 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbcKDXNA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Nov 2016 19:13:00 -0400
Received: by mail-it0-f66.google.com with SMTP id m138so714793itm.3
        for <linux-ext4@vger.kernel.org>; Fri, 04 Nov 2016 16:13:00 -0700 (PDT)
In-Reply-To: <20161104215105.waabpcf7zganrdbr@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_C6328369-F27B-4031-BB14-104BEC59B7B7
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Nov 4, 2016, at 3:51 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> On Fri, Nov 04, 2016 at 10:14:03AM -0600, Andreas Dilger wrote:
>>> 2.  In ext4_lookup(), if case insensitivity is enabled, and the
>>> directory lookup does not succeed, fall back to a linear search of the
>>> directory using using a case insensitive compare.  (This is slow, but
>>> it's faster compared to doing this in userspace).
>> 
>> Does it make sense to flag directories with whether entries are inserted
>> with the case-insensitive hash?  That allows the common case of having
>> case insensitivity always enabled or disabled working optimally.  Falling
>> back to linear search for every negative lookup would be prohibitive for
>> large directories.
> 
> I'm proposing that we not make any on-disk format changes for now.
> It's true that this means that we need to degrade to a O(N) brute
> force search, and that it is undefined if there are two files that are
> the same when case folding is enabled (e.g., if there is both a
> Makefile and makefile in the directory).
> 
> However, the horrible hacks that people have been using have these
> problems *already*.  Doing it in the kernel has a number of
> advantages: (1) it's faster since the FUSE hack or the userspace hack
> doesn't have to transfer the contents of the directory to userspace to
> do the case insensitive search, and (2) the O(N) search only happens
> in the cold cache case since we can rely on the dcache to cache the
> case-folded filename.  So it's far better than especially the FUSE and
> Samba implementations of case-folded lookups that I've seen.
> 
> 
>> What happens if filenames that collide after case folding are already
>> existing in the filesystem
> 
> As in the current schemes, it's undefined which file you get.
> 
> In practice it doesn't seem to be an issue since very often the
> directory starts empty and all of the file creates would be done in a
> case insensitive fashion.
> 
>> Is this conflating the htree ASCII case folding problem with Unicode?
>> It would still be possible to insert names into the htree using the hash
>> of the ASCII-folded names, regardless of what is done for Unicode folding.
>> Changing the folding method would make the filesystem slow with large
>> directories (possibly unusable for very large directories), but that could
>> be fixed by running "e2fsck -fD" on the filesystem to reindex directories.
> 
> Well, the issue is that I assume the ASCII case folding is not going
> to be long-term acceptible.  So sooner or later someone is going to
> want to try to insert a Unicode-8 case folding system into the kernel.
> I just don't want to have to deal with that mess.  (I don't get paid
> enough to deal with I18N, so this is going to be a situation of
> 'patches gratefully accepted').  So committing to an on-disk format
> when eventually people will want to add Unicode seems like more work
> than it's worth.
> 
> Eventually if we do want to use a case insensitive hash for the
> hash_tree, we'd have to add a new read-only feature, store the case
> folding algorithm used in the superblock, and then handle the
> conversion cases with tune2fs and/or e2fsck -fD, etc.  That's all a
> huge amount of work, and see previous comments of I'm not getting paid
> enough to deal with I18N.  So it's very likely that we wouldn't
> support converting from ASCII to Unicode 8 (again, unless someone
> wants to send me patches), or deal with what happens some number of
> years from now when the Unicode consortium publishes Unicode 9 (e.g.,
> how quickly do we need to support Unicode 9, etc.)
> 
> It's basically a question of tradeing off developer time with fast
> lookups when case insensitivity is turned on and the case is coming
> from the user (as opposed to coming from readdir) and the case is
> incorrect.  In the past, we've let the perfect be the enemy of the
> good.   And getting "perfect" is a massive pain in the tuckus.
> 
> So a very explicit goal in this proposal is to do something very low
> effort, and not painting ourselves into the corner.  Which is why
> doing something which does not have any on-disk format changes was a
> key part of the design.
> 
> If someone wants to do something "right", which means e2fsprogs and
> kernel changes, getting the Unicode translation code into the kernel
> (and dealing with the bikeshedding that will probably happen when we
> try to get generic Unicode support into the kernel), and that someone
> is a reasonably experienced ext4 developer so I'm not forced to
> reimplement prototype code, I'm certainly willing to entertain the
> discussion.  But the main reason why we havne't had this for decades
> was because (a) at least initially the people who ext4 to support case
> folding wanted us to support mutliple codepages instead of just
> Unicode/UTF-8, and (b) most of the ext4 developers aren't paid enough
> to deal with I18N.  :-)

The importance of "getting it right" depends on what you consider a
disk format change, and how often people are doing lookups with the
wrong case?  Presumably you have some motivation to implement this
functionality in the first place, and hopefully have some data on how
it is being used?

If the "linear search" case is rare, because people almost always look
up filenames using the right case, then that is half of the problem.

However, you are ignoring the negative lookup case, where the filename
doesn't exist at all.  If the kernel is falling back to a full linear
search for every negative lookup (e.g. binaries or libraries in a path)
then this could be punishing if the directory is large and/or there are
lots of path components (which happens at sites I've seen).  The negative
lookup case also doesn't even have the benefit of early exit when the
entry is found, but will always search the whole directory each time.

Hence, my thought that if someone wants to use case-insensitive lookups,
they probably want that to be true for a long time, and using the case-
insensitive hash to both find and insert the entry is best, even if the
folding method changes in the future.  In the worst case, it is no worse
than your linear-search fallback, but in the common case it will have
O(1) lookup and insertion.

I don't think that adding a new hash type for ASCII-folded half-md4 is
too much to ask, so that e2fsck knows how to handle it.  The kernel could
set this on new directories, and e2fsck can use it when running with
e2fsck -fD.  I don't think this requires a new read-only feature, since
the kernel will already handle unknown hash functions with linear search.
We still don't need to handle Unicode at this point (that would be a
different hash type), but avoids a partial solution with bad failure modes.

Cheers, Andreas






--Apple-Mail=_C6328369-F27B-4031-BB14-104BEC59B7B7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWB0V9XKl2rkXzB/gAQh7rBAAo04hdyUdpjrMBUX3banhqvUpRHbY+aA/
pQ7rN/gLUuqUAC0GJHiLeN39p1+KCw4rVcy03fKAQuG7zaQ3Us3uTPn46SWf6OWL
qpU5S8QNjLCtVmE+w6St/C9eWuZBTYvAKcjHcufG45ShIiVqVBcqX1PiLdOF1bEO
e8yaRhZDQ9PK6KdwBmjSoJJsIPYzOD8l38VWzDXFhrqzt6tvTWjzBQj1lud2xpJV
mea7brHhfjxWvZsoyDYGZg4TIYl1flr87wj7GpBAkq9MbGGHOyYbMSeKYlDR899t
16VAjmrPukAkKCWYeQviU4U1yj6W5oL73TN+zQgv06ZTGEr5j1y8olQ6k/CGBJHQ
tu9LkGnrG3v484X6L9ufGL8eTprpNlBCc3ImKjFSKeQqtjec6wsG02S0vkA/Sxuz
ndlUHaPAQXOesVEnigKHpcIxNbWuNmMhTT1egofg3xT9R7SwIc0oOm1U2/aQglJV
pIrUbg7Dhu32WPHgTLPUpTVuAlS0d9C69UGZN9KLuoT4oyyNrmw2uO0eTkPvwVlT
3JtXfOsxG+QSJTE3Y29dc8oUqZfXx7SHnnIQp6AQMoT6jyMPw7oA+sN57iyvtukx
21fYnmEVPcuDAH27iCSsOIfAu2C4L7oapcpvZmrzgmRunJ4oH1S5ao1qGsVqMkLM
9vFzWGXoGao=
=bIRx
-----END PGP SIGNATURE-----

--Apple-Mail=_C6328369-F27B-4031-BB14-104BEC59B7B7--
