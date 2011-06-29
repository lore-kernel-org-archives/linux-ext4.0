From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Subject: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Tue, 28 Jun 2011 23:22:14 -0500
Message-ID: <B5285968-90F7-4A0E-AB92-0179598E4C97@boeing.com>
References: <20110624134659.GB26380@quack.suse.cz>
 <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
 <20110624200231.GA32176@quack.suse.cz>
 <alpine.LFD.2.00.1106271312310.3845@dhcp-27-109.brq.redhat.com>
 <20110627140251.GI5597@quack.suse.cz>
 <alpine.LFD.2.00.1106271714350.3845@dhcp-27-109.brq.redhat.com>
 <20110627160140.GC2729@thunk.org>
 <2D8D1A30-C092-4163-B47A-BCEDACE536A3@boeing.com>
 <20110628093652.GA29978@quack.suse.cz>
 <CA718FEC-341E-4D17-90FA-6181A0487CC9@boeing.com>
 <20110628225714.GB15206@quack.suse.cz>
Reply-To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>, 615998@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
        Sean Ryle
	<seanbo@gmail.com>,
        "615998@bugs.debian.org" <615998@bugs.debian.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Sachin Sant
	<sachinp@in.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.615998.B615998.13093214719748@bugs.debian.org>
In-Reply-To: <20110628225714.GB15206@quack.suse.cz>
Content-Language: en-US
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
List-Id: linux-ext4.vger.kernel.org

On Jun 28, 2011, at 18:57, Jan Kara wrote:
> On Tue 28-06-11 14:30:55, Moffett, Kyle D wrote:
>> On Jun 28, 2011, at 05:36, Jan Kara wrote:
>>> Well, direct IO is atomic in data=3Djournal the same way as in data=3Do=
rdered.
>>> It can happen only half of direct IO write is done when you hit power
>>> button at the right moment - note this holds for overwrites.  Extending
>>> writes or writes to holes are all-or-nothing for ext4 (again both in
>>> data=3Djournal and data=3Dordered mode).
>>=20
>> My impression of journalled data was that a single-sector write would
>> be written checksummed into the journal and then later into the actual
>> filesystem, so it would either complete (IE: journal entry checksum is
>> OK and it gets replayed after a crash) or it would not (IE: journal
>> entry does not checksum and therefore the later write never happened
>> and the entry is not replayed).
>=20
> Umm, right. This is true. That's another guarantee of data=3Djournal mode=
 I
> didn't think of.

Ok, that's what I had hoped was the case.  That doesn't help much for
overwrites of variable-length data (EG: text files), but it does help
protect stuff like MySQL MyISAM (which does not do journalling).  It's
probably unnecessary for MySQL InnoDB, which *does* have its own journal.


>>> Page sized and page aligned writes are atomic (in both data=3Djournal a=
nd
>>> data=3Dordered modes). When a write spans multiple pages, there are cha=
nces
>>> the writes will be merged in a single transaction but no guarantees as =
you
>>> properly write.
>>=20
>> I don't know that our definitions of "atomic write" are quite the same..=
.
>>=20
>> I'm assuming that filesystem "atomic write" means that even if the disk
>> itself does not guarantee that a single write will either complete or it
>> will be discarded, then the filesystem will provide that guarantee.
>=20
> OK. There are different levels of "disk does not guarantee atomic writes"
> though. E.g. flash disks don't guarantee atomic writes but even more they
> actually corrupt unrelated blocks on power failure so any filesystem is
> actually screwed on power failure. For standard rotating drives I'd rely =
on
> the drive being able to write a full fs block (4k) although I agree noone
> really guarantees this.

Well, I've seen a study somewhere that some spinning media actually *can*
tend to corrupt a nearby sector or two during a power failure, depending
on exactly what the input voltage does.  The better ones certainly have
a voltage monitor that automatically cuts power to the heads when it goes
below a critical level.

And the better Flash-based media actually *do* provide atomic write
guarantees due to the wear-levelling and flash-remapping engine.  In
order to protect their mapping table metadata and avoid very large
write amplification they will use a system similar to a log-structured
filesystem to accumulate a bunch of small random writes into one larger
write.  Since they're always writing into empty space and then doing an
atomic metadata update, their writes are always effectively atomic,
even for data.

My informal testing of the Intel X-18M drives seems to indicate that
they work that way.

Cheers,
Kyle Moffett=
