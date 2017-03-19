From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] Add largedir feature
Date: Sun, 19 Mar 2017 00:13:00 -0600
Message-ID: <4FA5F6BA-7264-42E3-B4E7-2EAD6FDD0AB1@dilger.ca>
References: <1489657877-34478-1-git-send-email-artem.blagodarenko@seagate.com>
 <CE3A3FB1-8DE6-476A-8386-94D590B17A23@dilger.ca>
 <E3BFD2D7-CCEF-4A10-A4E6-ED634C56436F@gmail.com>
 <07B442BA-D335-4079-8691-0AB1FAD7368F@dilger.ca>
 <18FAA61C-DE3C-42C7-A8A4-BB2CDD3C5D24@gmail.com>
 <20170318162953.ubn3lvglxqq6ux2e@thunk.org>
 <EA1BCCB1-AEC7-4193-823B-6230B6860C0C@gmail.com>
 <20170319003928.shnxljfcpvmovcw4@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_DB022BAB-6586-4C10-9FF5-196D23218CB2";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Yang Sheng <yang.sheng@intel.com>,
        Zhen Liang <liang.zhen@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35458 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751369AbdCSGOT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Mar 2017 02:14:19 -0400
Received: by mail-it0-f65.google.com with SMTP id y18so11414815itc.2
        for <linux-ext4@vger.kernel.org>; Sat, 18 Mar 2017 23:13:05 -0700 (PDT)
In-Reply-To: <20170319003928.shnxljfcpvmovcw4@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_DB022BAB-6586-4C10-9FF5-196D23218CB2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On Mar 18, 2017, at 6:39 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> On Sat, Mar 18, 2017 at 08:17:55PM +0300, Alexey Lyashkov wrote:
>>>> 1) readdir. It tries to read all entries in memory before send to
>>>> the user. currently it may eats 20*10^6 * 256 so several gigs, so
>>>> increasing it size may produce a problems for a system.
>>>=20
>>> That's not true.  We normally only read in one block a time.  If =
there
>>> is a hash collision, then we may need to insert into the rbtree in a
>>> subsequent block's worth of dentries to make sure we have all of the
>>> directory entries corresponding to a particular hash value.  I think
>>> you misunderstood the code.
>>=20
>> As i see it not about hash collisions, but about merging a several
>> blocks into same hash range on up level hash entry.  so if we have a
>> large hash range originally assigned to the single block, all that
>> range will read at memory at single step.  With =C2=ABaged=C2=BB =
directory
>> when hash blocks used already - it=E2=80=99s easy to hit.
>=20
> If you look at ext4_htree_fill_tree(), we are only iterating over the
> leaf blocks.  We are using a 31-bit hash, where the low-order bit is
> one if there has been a collision.  In that case, we need to read the
> next block to make sure all of the directory entries which have the
> same 31-bit hash are in the rbtree.

I guess the main concern here is that insertion into an htree directory
is essentially random based on the hash, so for very large directories
the whole directory (htree and leaf blocks) needs to fit into RAM or the
performance will suffer since every leaf block will need to be read from
disk for every create/lookup/delete.

That said, the maximum size of a 2-level htree directory is about 1GB,
and servers have 128 or 256GB of RAM these days, so I don't think this
will be a huge problem.  We also have a tunable that can limit the
maximum directory size if this becomes a problem.

> And I'll note that this is a problem that can be solved without
> changing the on-disk format, but simply adding code so we can merge
> adjacent directory entry blocks.  The main reason why it hasn't been
> done is (a) no one has sent me patches, and (b) I haven't seen
> workloads where this has been anything other than a theoretical /
> academic concern.
>=20
> You seem very passionate about this.  Is this a problem you've
> personally seen?  If so, can you give me more details about your use
> case, and how you've been running into this issue?  Instead of just
> arguing about it from a largely theoretical perspective?

We have seen large directories at the htree limit unable to add new
entries because the htree/leaf blocks become fragmented from repeated
create/delete cycles.  I agree that handling directory shrinking
would probably solve that problem, since the htree and leaf blocks
would be compacted during deletion and then the htree would be able
to split the leaf blocks in the right location for the new entries.

Cheers, Andreas

>> Yes, i expect to have some seek penalty. But may testing say it too =
huge
>> now.  directory creation rate started with 80k create/s have dropped
>> to the 20k-30k create/s with hash tree extend to the level 3.  Same
>> testing with hard links same create rate dropped slightly.
>=20
> So this sounds like it's all about the seek penalty of the _data_
> blocks.  If you use hard links the creation rate only dropped a
> little, am I understanding you correctly?  (Sorry, your English is a
> little fracturered so I'm having trouble parsing the meaning out of
> your sentences.)
>=20
> So what do you think the creation rate _should_ be?  And where do you
> think the time is going to, if it's not the fact that we have to place
> the data blocks further and further from the directory?  And more
> importantly, what's your proposal for how to "fix" this?
>=20
>>> As for the other optimizations --- things like allowing parallel
>>> directory modifications, or being able to shrink empty directory
>>> blocks or shorten the tree are all improvements we can make without
>>> impacting the on-disk format.  So they aren't an argument for =
halting
>>> the submission of the new on-disk format, no?
>>>=20
>> It=E2=80=99s argument about using this feature. Yes, we can land it, =
but it decrease an expected speed in some cases.
>=20
> But there are cases where today, the workload would simply fail with
> ENOSPC when the directory couldn't grow any farther.  So in those
> cases _maybe_ there is something we could do differently that might
> make things faster, but you have yet to convince me that the
> fundamental fault is one that can only be cured by an on-disk format
> change.  (And if you believe this is to be true, please enlighten us
> on how we can make the on-disk format better!)
>=20
> Cheers,
>=20
> 					- Ted


Cheers, Andreas






--Apple-Mail=_DB022BAB-6586-4C10-9FF5-196D23218CB2
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYziFtpIg59Q01vtYRAmKnAJ9wBQWm+b8IV6/ziSaaiqiRu9D4IQCeOMwl
cctKTys5NWhYY2b/oalIbp8=
=nK63
-----END PGP SIGNATURE-----

--Apple-Mail=_DB022BAB-6586-4C10-9FF5-196D23218CB2--
