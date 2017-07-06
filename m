From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Some jbd2 philosophy about credits estimation and other things
Date: Thu, 6 Jul 2017 15:18:53 -0600
Message-ID: <24B0A43D-B2C3-4BF4-8E97-0BA97F976204@dilger.ca>
References: <20170704175441.ljipnhmgli6npdt6@thunk.org>
 <20170706171906.GA4096@magnolia>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_B72FCC8F-8002-43BA-A3E7-4D1B4A127048";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        Yang Sheng <yang.sheng@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>,
        tahsin@google.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34256 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751899AbdGFVTD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Jul 2017 17:19:03 -0400
Received: by mail-it0-f65.google.com with SMTP id o202so2483352itc.1
        for <linux-ext4@vger.kernel.org>; Thu, 06 Jul 2017 14:19:02 -0700 (PDT)
In-Reply-To: <20170706171906.GA4096@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_B72FCC8F-8002-43BA-A3E7-4D1B4A127048
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 6, 2017, at 11:19 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Tue, Jul 04, 2017 at 01:54:41PM -0400, Theodore Ts'o wrote:
>> I'm going to be making some changes to two recent feature patches =
(the
>> largedir feature patch and the xattr duplication patch) to fix up =
some
>> potential bugs caused by under-estimating the number of credits =
needed
>> which can cause ext4 to get quite unhappy:
>>=20
>> EXT4-fs: ext4_xattr_block_set:2023: aborting transaction: error 28 in =
__ext4_handle_dirty_metadata
>> EXT4-fs error (device dm-2): ext4_xattr_block_set:2023: inode =
#131078: block 589866: comm fsstress: journal_dirty_metadata failed: =
handle type 10 started at line 2411, credits 5/0, errcode -28
>>=20
>> While I was looking into this, I realized that there are some
>> implementation details about how the jbd2 layer works that haven't
>> written down, and it might be useful to document it for everyone.
>> (This probably needs to go into the ext4 wiki, with some editing.)
>=20
> Additionally ext4-jbd2.h ?
>=20
>> In general, under-estimating of the number of credits needed is far
>> worse than over-estimating.  Under-estimating can cause the above,
>> which will end up marking the file system corrupt.  We can actually =
do
>> better; in fact, we probably ought to do is to try to see if we can
>> extend the transaction, print an ext4 warning plus a WARN_ON(1) to =
get
>=20
> I don't know if that's a good idea -- I'd rather train the developers
> that they cannot underestimate ever than let them paper over things =
like
> this that will eventually blow out on someone else's machine.
>=20
> But I guess a noisy WARN would get peoples' attention.

The current behaviour of marking the filesystem in error is probably =
enough
to get the user's attention... :-/  However, that mostly punishes the =
user
and takes potentially a long time to get to the developer and back to =
the
user in a distro kernel in a production environment.

For the Lustre/ext4 interface we have our own "update" accounting to =
tracks
how many primitive operations we declared (e.g. directory insert/delete,
inode alloc, file write/append/truncate, setattr, setxattr, quota, etc)
vs. how many updates were actually done on that handle.  During =
development
and testing, a /proc tunable is set to triggers an assertion, with stack
trace and dump of declared vs. used credits, if the declared updates are
exceeded.  During normal runtime this at most generates a warning and =
the
code continues on, and will only fail if the underlying ext4/jbd2 =
credits are
exceeded.  In the overwhelming majority of cases this avoids causing a =
hard
system failure for what is essentially worst-case-scenario debugging.


Even though it might be 20 years late, it wouldn't be a bad idea to make
ext4/jbd2 more robust in this area as well, since running out of =
transaction
credits on a single handle is very unlikely to actually induce a real =
failure.
The code can still abort the filesystem if it isn't possible to add =
credits
to the transaction handle (which isn't worse than it does today), but in =
the
(IMHO) very common case where it could easily continue running and just =
dump
a stack trace with some debug info I think it makes sense to do so.


I recall in the olden days of early ext3 development that Andrew Morton =
had
a debug mode for JBD that would save a list all of the buffer heads that =
were
dirtied as part of a transaction handle, so that it would be possible to =
do
root-cause analysis of why the credits were exceeded.  It essentially =
kept a
list for each handle with either a pointer to the bh or the block number =
and
type of each buffer (e.g. SB, bitmap, GDT, inode, =
index/indirect/directory
block, etc.), and if the credits ran out it could dump that list.

It probably wouldn't be too hard to make such debugging dynamic based on =
the
function that allocated the handle, and if the credit exhaustion is ever
triggered at runtime it turns on the debugging for this callsite for =
every
new handle (assuming the handle could be extended in this case and the =
journal
is not aborted), until the problem is hit again and it dumps a stack and =
the
list of blocks/types for each one, then turns debugging off again.  The =
reason
this needs to be dynamic is that often the credit exhaustion problems =
are only
hit under very unusual filesystem aging and concurrent workloads.

As for overhead of such debugging, it would check in =
__ext4_journal_start_sb()
a (usually empty) linked list if the debug mode was enabled for a given
type/line combination (which is passed to jbd2_journal_start() already), =
add
a few flags in the handle to track the debug state (some bits still =
available),
the original requested credits (also already stored in the handle), and =
an
extra pointer for the memory to track the buffers dirtied under this =
handle
(one entry per credit, can be kvmalloc'd only if debugging is enabled).  =
We
could overload h_start_jiffies for this pointer if the handle debug flag =
is set,
since h_start_jiffies is only used in a single tracepoint, and we don't =
need
to be able to trace transaction performance at the same time as =
isolating a
credit overflow.

Cheers, Andreas

>> a stack dump.  If we can't continue, we will have to force an
>> ext4-error and abort the journal, since if we run out of space, we =
can
>> end up in a deadlock: in order to free space in the journal, we need
>> to do a commit, but we can't do a commit because handles are open and
>> we can't complete them because we're out of space.
>>=20
>> Also, a typical transaction has room for thousands of blocks, and a
>> handle is usually only open for a very short time.  Once a handle is
>> stopped, any unused credits are released back to the journal.  For
>> this reason, if we estimate that we need to modify 20 blocks
>> (credits), but we only need to modify 8 blocks, 4 of which have
>> already been modify in the current transaction --- this is not a
>> tragedy.  We only used up 4 new blocks in the journal by the time the
>> handle is stopped, but that's OK.  Once the handle is stopped the
>> "cost" of the over-estimation is gone.
>>=20
>> What is the "cost" of the over-estimation?  Well, we need to make =
sure
>> that there will be enough room in the journal to write the current
>> transaction (plus have some slack space for the next transaction).  =
So
>> if we vastly over-estimate the number of blocks needed when we start =
a
>> handle, and the sum of all of the credits of currently started =
handles
>> is greater than free space in the journal minus some slack space,
>> instead of starting the new handle, the thread will block, and all
>> attempts to start new handles will block, until all of the currently
>> running handles have completed and a current transaction can start
>> committing.
>>=20
>> So over-estimating by a few 10's of credits is probably not =
noticeable
>> at all.  Over-estimating by hundreds of credits can start causing
>> performance impacts.  How?  By forcing transaction to close earlier
>> than the normal 5 second timeout due of a perceived lack of space,
>> when the journal is almost full due to a credit over-estimation.  =
Even
>> so, the performance impact is not necessarily that great, and
>> typically only shows up under heavy load --- and we or the system
>> administrator can mitigate this problem fairly easily by increasing
>> the journal size.
>=20
> /me wonders if it'd be useful to track how closely the estimates fit
> reality in debugfs to make it easier to spot-check how good of a job
> we're all doing?
>=20
>> So while there may be a desire out of professional pride to make the
>> credit estimation be as accurate as possible, getting the credit
>> estimation exactly write is not really critical.  It's for this =
reason
>> that we always add EXT4_INDEX_EXTRA_TRANS_BLOCKS to the credits
>> without testing to see if the HTree feature is enabled.  An extra 8
>> (soon to be 12) blocks doesn't really matter all that much.
>=20
> As general documentation, this seems fine as-is up to here.  You could
> probably rework the last two paragraphs too.
>=20
> --D
>=20
>> The reason why we do try to do conditionalized credits based on =
quotas
>> is because when quota is enabled, some of the calculations for the
>> number of credits that are needed were extremely high.  This was
>> partially addressed by Jan Kara's change to move the call to
>> dquot_initialize to a separate transaction.  (eb9cc7e16b3: ext4: move
>> quota initialization out of inode allocation transaction)
>>=20
>> The inode allocation path is still one where if we can reduce number
>> of credits needed, it can be a win.  (It currently has a worst case =
of
>> around 200 blocks, per Jan's comments in eb9cc7e16b3.)  Fortunately,
>> there are some assumptions we can make about inode allocation to
>> simplify things: (a) the acl will be a duplicate of the directory's
>> default acl; (b) the SELinux label is generally not that huge, and =
(c)
>> the encryption metadata is also fairly small, and (d) there is no
>> pre-existing inline data to worry about.  All of this means that we
>> don't need to worry about the inline data or EA-in-inode features, =
and
>> so we can probably rely on EXT4_XATTR_TRANS_BLOCKS estimate instead =
of
>> using more complex calculations found in __ext4_xattr_set_credits().
>>=20
>> Cheers,
>>=20
>> 						- Ted


Cheers, Andreas






--Apple-Mail=_B72FCC8F-8002-43BA-A3E7-4D1B4A127048
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZXqk/pIg59Q01vtYRAiSzAKCGaDWhCV/C6QOiWzOwgm+sOPHNZgCgzPgO
fCDpifeFAgm7fAKUBr6Fl+s=
=rsaP
-----END PGP SIGNATURE-----

--Apple-Mail=_B72FCC8F-8002-43BA-A3E7-4D1B4A127048--
