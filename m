From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Subject: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Tue, 28 Jun 2011 14:36:21 -0500
Message-ID: <28CB08E7-2850-498A-A8EB-A9B872D31F8F@boeing.com>
References: <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
 <20110624134659.GB26380@quack.suse.cz>
 <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
 <20110624200231.GA32176@quack.suse.cz>
 <alpine.LFD.2.00.1106271312310.3845@dhcp-27-109.brq.redhat.com>
 <20110627140251.GI5597@quack.suse.cz>
 <alpine.LFD.2.00.1106271714350.3845@dhcp-27-109.brq.redhat.com>
 <20110627160140.GC2729@thunk.org>
 <2D8D1A30-C092-4163-B47A-BCEDACE536A3@boeing.com>
 <20110628093652.GA29978@quack.suse.cz> <20110628141650.GH2729@thunk.org>
Reply-To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>, 615998@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Jan Kara <jack@suse.cz>, Lukas Czerner <lczerner@redhat.com>,
        Sean Ryle
	<seanbo@gmail.com>,
        "615998@bugs.debian.org" <615998@bugs.debian.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Sachin Sant
	<sachinp@in.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.615998.B615998.130928980425772@bugs.debian.org>
In-Reply-To: <20110628141650.GH2729@thunk.org>
Content-Language: en-US
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
List-Id: linux-ext4.vger.kernel.org

On Jun 28, 2011, at 10:16, Ted Ts'o wrote:
>>> My basic impression is that the use of "data=3Djournalled" can help
>>> reduce the risk (slightly) of serious corruption to some kinds of
>>> databases when the application does not provide appropriate syncs
>>> or journalling on its own (IE: such as text-based Wiki database files).
>=20
> Yes, although if the application has index files that have to be
> updated at the same time, there is no guarantee that the changes that
> survive after a system failure (either a crash or a power fail),
> unless the application is doing proper application-level journalling
> or some other structured.

Manually rebuilding application indexes and clearing out caches is fine;
with a badly written application I'd have to do that anyways.  I just want
to reduce the risk that I actually corrupt data, and it sounds like that's
what data-journalling will help with.

>> To sum up, the only additional guarantee data=3Djournal offers against
>> data=3Dordered is a total ordering of all IO operations. That is, if you=
 do a
>> sequence of data and metadata operations, then you are guaranteed that
>> after a crash you will see the filesystem in a state corresponding exact=
ly
>> to your sequence terminated at some (arbitrary) point. Data writes are
>> disassembled into page-sized & page-aligned sequence of writes for purpo=
se
>> of this model...
>=20
> data=3Djournal can also make the fsync() operation faster, since it will
> involver fewer seeks (although it will require a greater write
> bandwidth).  Depending on the write bandwidth, you really need to
> benchmark things to be sure, though.

Hm, so this would actually be very beneficial for a mail spool directory
then, because mail servers are supposed to fsync each email received in
order to guarantee that it will not be lost before it acknowledges receipt
to the SMTP client.

Thanks again!

Cheers,
Kyle Moffett=
