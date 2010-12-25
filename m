From: Neil Brown <neilb@suse.de>
Subject: Re: Atomic non-durable file write API
Date: Sun, 26 Dec 2010 08:40:07 +1100
Message-ID: <20101226084007.7939aabc@notabene.brown>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
	<AANLkTimZtza_t8s1uOrE3BFfb-8FELjW95nrQz3RULWd@mail.gmail.com>
	<AANLkTikhDgJNny74nyBugg9cUmxC9j8Eo8YY4Fr3fm=5@mail.gmail.com>
	<4D0A7278.3080506@gmail.com>
	<1292710543.17128.14.camel@nayuki>
	<AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>
	<AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>
	<20101224085126.2a7ff187@notabene.brown>
	<AANLkTikHzECjyNNJC=-0x+-WgNrY=-PjzJnVt=G2NHX_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikHzECjyNNJC=-0x+-WgNrY=-PjzJnVt=G2NHX_@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 24 Dec 2010 12:17:46 +0100 Olaf van der Spek <olafvdspek@gmail.=
com>
wrote:

> On Thu, Dec 23, 2010 at 10:51 PM, Neil Brown <neilb@suse.de> wrote:
> > You are asking for something that doesn't exist, which is why no-on=
e can tell
> > you want the answer is.
>=20
> It seems like a very common and basic operation. If it doesn't exist
> IMO it should be created.
>=20
> > The only mechanism for synchronising different filesystem operation=
s is
> > fsync. =A0You should use that.
> >
> > If it is too slow, use data journalling, and place your journal on =
a
> > small low-latency device (NVRAM??)
>=20
> This isn't about some DB-like app, it's about normal file writes, lik=
e
> archive extractions, compiling, editors, etc.
>=20

Yes, it might be nice to have a very low cost way to make those safer a=
gainst
corruption during a crash.
It would have to be *very* low cost as in most cases the cost of cleani=
ng up
after the crash instead (e.g. 'make clean') is quite low.  But people d=
o
sometime edit /etc/init.d files with an ordinary editor and it would be
rather embarrassing if a crash just at the wrong time left some critica=
l file
incomplete, and maybe it would be easier to teach editors to fsync befo=
re
rename for files in /etc .....

So what would this mechanism really look like?  I think the proposal is=
 to
delay committing the rename until the writeout of the file is complete,
without accelerating the writeout.
That would probably require delaying all updates to the directory until=
 the
writeout was complete, as trying to reason about which changes were dep=
endent
and which were independent is unlikely to be easy.

So as soon as you rename a file, you create a dependency between the fi=
le and
the directory such that no update for the directory may be written whil=
e any
page in the file is dirty.  Conversely, any fsync of the directory woul=
d
fsync the file as well.

Any write to the file should probably break the dependency as you can n=
o
longer be sure what exactly the rename was supposed to protect.

I suspect that much of the infrastructure for this could be implemented=
 in
the VFS/VM.  Certainly the dependency linkage between inodes, created o=
n
rename, destroyed on write or fsync or when writeout on the inode compl=
etes,
and the fsync dependency could be common code.  Preventing writeout of
directories with dependent files would need some fs interaction. You co=
uld
probably prototype in ext2 quite easily to do some testing and collecti=
on
some numbers on overhead.

I think this would be an interesting project for someone to do and I wo=
uld be
happy to review any patches.  Whether it ever got further than an inter=
esting
project would depend very much on how intrusive it was to other filesys=
tems,
how much over head it caused, and what actual benefits resulted.
If anyone wanted to pursue this idea, they would certainly need to addr=
ess
each of those in their final proposal.

I think there could be room for improved transactional semantics in Lin=
ux
filesystems.  This might be what they should look like ... don't know y=
et.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
