From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: Re: [PATCH] Add largedir feature
Date: Sun, 19 Mar 2017 07:19:01 +0300
Message-ID: <F80699F8-1D07-4DA4-AAFB-FF1892F1B5A2@gmail.com>
References: <1489657877-34478-1-git-send-email-artem.blagodarenko@seagate.com>
 <CE3A3FB1-8DE6-476A-8386-94D590B17A23@dilger.ca>
 <E3BFD2D7-CCEF-4A10-A4E6-ED634C56436F@gmail.com>
 <07B442BA-D335-4079-8691-0AB1FAD7368F@dilger.ca>
 <18FAA61C-DE3C-42C7-A8A4-BB2CDD3C5D24@gmail.com>
 <20170318162953.ubn3lvglxqq6ux2e@thunk.org>
 <EA1BCCB1-AEC7-4193-823B-6230B6860C0C@gmail.com>
 <20170319003928.shnxljfcpvmovcw4@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Andreas Dilger <adilger@dilger.ca>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Yang Sheng <yang.sheng@intel.com>,
        Zhen Liang <liang.zhen@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32786 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750725AbdCSETG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Mar 2017 00:19:06 -0400
Received: by mail-wm0-f68.google.com with SMTP id n11so9118712wma.0
        for <linux-ext4@vger.kernel.org>; Sat, 18 Mar 2017 21:19:04 -0700 (PDT)
In-Reply-To: <20170319003928.shnxljfcpvmovcw4@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

sorry for english..
> 19 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2017 =D0=B3., =D0=B2 3:39, Theodore =
Ts'o <tytso@mit.edu> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>=20
> On Sat, Mar 18, 2017 at 08:17:55PM +0300, Alexey Lyashkov wrote:
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
looks we say about same but with different words.
based on dx code, up level hash block have a records - {hash1, block1} =
{hash2, block1}=E2=80=A6
so any records with hash range {hash1, hash2} will live on block1.
right ?=20
so question how much {hash1, hash2} distance may be, looks you name it =
as "hash collision".


> You seem very passionate about this.  Is this a problem you've
> personally seen?  If so, can you give me more details about your use
> case, and how you've been running into this issue?  Instead of just
> arguing about it from a largely theoretical perspective?
>=20
It problem was seen with Lustre MDT code  after large number =
create/unlinks.
but it seen only few times.
Other hits isn=E2=80=99t conformed.



>> Yes, i expect to have some seek penalty. But may testing say it too =
huge now.
>> directory creation rate started with 80k create/s have dropped to the =
20k-30k create/s with hash tree extend to the level 3.
>> Same testing with hard links same create rate dropped slightly.
>=20
> So this sounds like it's all about the seek penalty of the _data_
> blocks. =20
no.

> If you use hard links the creation rate only dropped a
> little, am I understanding you corretly?
yes and no. hard link create rate dropped a little, but open()+close =
tests dropped a large.
No writes, no data blocks, just inode allocation.



>  (Sorry, your English is a
> little fracturered so I'm having trouble parsing the meaning out of
> your sentences.)
it=E2=80=99s my bad :(
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
