From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] A proposal for adding case insensitive lookups to ext4
Date: Fri, 4 Nov 2016 10:14:03 -0600
Message-ID: <E33408BD-68CC-49E4-9B32-EC06DB057509@dilger.ca>
References: <20161103172842.q7avc7rztny3zndd@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_DFE35E55-A39D-494C-B447-2651FA9B8B07"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, guy@linux.com,
        jra@google.com, drosen@google.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33444 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934707AbcKDQOJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Nov 2016 12:14:09 -0400
Received: by mail-oi0-f65.google.com with SMTP id x4so13468043oix.0
        for <linux-ext4@vger.kernel.org>; Fri, 04 Nov 2016 09:14:09 -0700 (PDT)
In-Reply-To: <20161103172842.q7avc7rztny3zndd@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_DFE35E55-A39D-494C-B447-2651FA9B8B07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Nov 3, 2016, at 11:28 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> HTML version (which will get updated in response to comments):
> 
>     https://thunk.org/tytso/casei-fs.html
> 
> 
> # A proposal for adding case insensitive lookups to ext4
> 
> ## Theodore Ts'o
> ## Version 0.10
> 
> ### Introduction
> 
> Over the years there has been a desire to add case insensitive lookups
> to ext 2/3/4.  The reason why this hasn't happened is doing it right
> is hard.  Unfortunately, the workarounds that people have been using
> in the absense of first class support for case insensitive lookups are
> slow, and evade all of the problems that make this problem hard
> anyway.
> 
> Hence, I think it's worthwhile to outline what could be done to allow
> ext4 to support case insensitive that would be more efficient and less
> hacky than some other solutions (e.g., slow FUSE file systems and
> hacky wrapfs-based solutions that are subject to crashes when run
> under fsstress).
> 
> This proposal does not make any on-disk format changes, but rather
> adds a mount option which causes lookups to be case insensitive, while
> case would be preserved in the directory entries when they are created
> and returned via readdir().
> 
> ### Changes to be made to ext4
> 
> 1.  If case-insensitivity is enabled, override the default dcache hash
> and compare operations to ones that are case insensitive in ext4's
> dcache_operations structure.
> 
> 2.  In ext4_lookup(), if case insensitivity is enabled, and the
> directory lookup does not succeed, fall back to a linear search of the
> directory using using a case insensitive compare.  (This is slow, but
> it's faster compared to doing this in userspace).

Does it make sense to flag directories with whether entries are inserted
with the case-insensitive hash?  That allows the common case of having
case insensitivity always enabled or disabled working optimally.  Falling
back to linear search for every negative lookup would be prohibitive for
large directories.

Depending on the filename length and the size of the directory, it may
still be faster to do 2^name_length lookups with the different case
combinations than a full linear search for each lookup (i.e. when
(1 << name_length < dir_blocks) this repeated lookup is more efficient).
Avoiding linear searching is most important for large directories, and
this becomes worthwhile for increasingly long filenames.

> ### Limitations
> 
> 1.  Like all of the FUSE and in-kernel searches, case insensitivity
> will be implemented using strcasecmp and tolower().  This implies that
> only ASCII case folding will be accepted.  One of the problems of
> using Unicode is that it is not a fixed target.  The case folding
> algorithm is changing as new scripts are added; if someone wants to
> add support for Unicode case folding, it should be added to the
> kernel, with someone assigned with the headache of updating the case
> folding algorithm when new versions of Unicode are issued.

What happens if filenames that collide after case folding are already
existing in the filesystem (e.g. include/uapi/linux/netfilter/xt_*.h
and net/netfilter/xt_*.c are examples of this, and it is a bit sad this
was exposed as part of uapi instead of giving the files useful names)?
Presumably that would prevent one of the filenames from being looked
up, or would it still be able to find both if the correct case was used?

> 2.  If the lookup is done using the filename as it is stored in the
> directory, lookups will be O(1) if the dir_index (htree) ext4 file
> system feature is enabled (which is the default).  It might be
> possible to use a case insensitive hash for the htree feature.
> However, if we do this, then the hash could be broken by changes to
> use Unicode, and if we do implement this with Unicode 8.0.0 support,
> the on-disk format could be broken by future Unicode updates.  So
> adding support for case O(1) lookups when case is not preserved by the
> filename provided by the user is highly unlikely.  (I will note that
> none of the kludges commonly in use support Unicode anyway, so this
> proposal is no worse than those kludges, and my personal approach is
> to exert a very strong Somebody Else's Problem field and hope someone
> else comes up with a solution for us.)

Is this conflating the htree ASCII case folding problem with Unicode?
It would still be possible to insert names into the htree using the hash
of the ASCII-folded names, regardless of what is done for Unicode folding.
Changing the folding method would make the filesystem slow with large
directories (possibly unusable for very large directories), but that could
be fixed by running "e2fsck -fD" on the filesystem to reindex directories.

The filesystem would remain functional even if the folding method changed,
and even without running "e2fsck -fD" it would eventually get better as
new files are added with the right hash and old files are deleted.

Cheers, Andreas

> 3.  Some of the hacky alternatives are also trying to support
> Android's "unique" file permissions scheme.  Support for this is out
> of scope for this proposal, although I do acknowledge we will need to
> come up with a clean way of implementing those permissions-related
> requirements before we have a complete, clean, bug-free, upstreamable
> solution for Android.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_DFE35E55-A39D-494C-B447-2651FA9B8B07
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWByzzHKl2rkXzB/gAQh4hRAAlxlR8HkuNVvSJR0Dpyh71k03uiW9qUX0
h4j3PtQj0J7RNFffwgHR3A6R4IKLnQDI+GHmMQrQEQlIvdidtIH8OpXHHnrLXa92
vkoS7A3XhI5sXughSXy6+Vghuix0nUyiqePoASEJANMkPR4i7dA28w4av6pCUcfP
WXda0+oGLslwU3uVQ8ic1l+gSqqfwgChYZBG3HG7Ll+doAFYprfdgO+vCaHTHMWQ
kRdfJyJkLlPY8Bm7+Fnkrw8INLP0Qmow0agtav5oFiPehW7Q/M5L7wHlChiGuxHA
XrERmu7eLDl9XJGKZ1nQBBj4NNaMZlsKYzN1JgLprkBOE3xeMIyxO/SriqONHNGG
HKxON29NS66XXePITugrUOYtmdehzzSyY+b6rMOWWJ7z3So+c/NPa2EgRemw3woH
UyQrnbkK12ALaRo1WAwPuTniJJVC8lhkJETUpTcYHf9g2XWbrjiVCWFnyFOFkIlu
sG4pqFIa703PI7UswLAfEOw0Td/6LC2N1e53LvH96B43U1izm50R7igSCj8x2KFA
nqZy//51wXlcuVvRT5fFukt3x4MeukqEIjOsjZdwkpXKrTeRtPpsStZYaVQSgEH+
N6zcMj6FPzZCGZilsqkgx4Q5PSBB9joF2qhVn1rurzIsEkSA9r7hLwmMZujk03xd
znMNixekCoo=
=oAUV
-----END PGP SIGNATURE-----

--Apple-Mail=_DFE35E55-A39D-494C-B447-2651FA9B8B07--
