From: Vishal Verma <vishal@kernel.org>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Tue, 26 Apr 2016 08:58:51 -0600
Message-ID: <1461682731.26226.20.camel@kernel.org>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	 <1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	 <x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	 <20160420205923.GA24797@infradead.org> <1461434916.3695.7.camel@intel.com>
	 <20160425083114.GA27556@infradead.org> <1461604476.3106.12.camel@intel.com>
	 <20160425232552.GD18496@dastard> <1461628381.1421.24.camel@intel.com>
	 <20160426004155.GF18496@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "hch@infradead.org" <hch@infradead.org>, "jack@suse.cz" <jack@suse.cz>,
 "axboe@fb.com" <axboe@fb.com>, "linux-nvdimm@ml01.01.org"
 <linux-nvdimm@ml01.01.org>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,  "viro@zeniv.linux.org.uk"
 <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org"
 <linux-ext4@vger.kernel.org>, "Wilcox, Matthew R"
 <matthew.r.wilcox@intel.com>
To: Dave Chinner <david@fromorbit.com>, "Verma, Vishal L"
	 <vishal.l.verma@intel.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160426004155.GF18496@dastard>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2016-04-26 at 10:41 +1000, Dave Chinner wrote:
> <>

> > The application doesn't have to scan the entire filesystem, but
> > presumably it knows what files it 'owns', and does a fiemap for
> > those.
> You're assuming that only the DAX aware application accesses it's
> files.=C2=A0=C2=A0users, backup programs, data replicators, fileystem
> re-organisers (e.g.=C2=A0=C2=A0defragmenters) etc all may access the fi=
les and
> they may throw errors. What then?

In this scenario, backup applications etc that try to read that data
before it has been replaced will just hit the errors and fail..

>=C2=A0

<>

> > The data that was lost is gone -- this assumes the application has
> > some
> > ability to recover using a journal/log or other redundancy - yes,
> > at the
> > application layer. If it doesn't have this sort of capability, the
> > only
> > option is to restore files from a backup/mirror.
> So the architecture has a built in assumption that only userspace
> can handle data loss?
>=20
> What about filesytsems like NOVA, that use log structured design to
> provide DAX w/ update atomicity and can potentially also provide
> redundancy/repair through the same mechanisms? Won't pmem native
> filesystems with built in data protection features like this remove
> the need for adding all this to userspace applications?
>=20
> If so, shouldn't that be the focus of development rahter than
> placing the burden on userspace apps to handle storage repair
> situations?

Agreed that file systems like NOVA can be designed to handle this
better, but haven't you said in the past that it may take years for a
new file system to become production ready, and that DAX is the until-
then solution that gets us most of the way there.. I think we just want
to ensure that current-DAX has some way to deal with errors, and these
patches provide an admin-intervention recovery path and possibly
another if the app wants to try something fancy for recovery.

<>
>=20
> >=C2=A0
> > To summarize, the two cases we want to handle are:
> > 1. Application has inbuilt recovery:
> > =C2=A0 - hits badblock
> > =C2=A0 - figures out it is able to recover the data
> > =C2=A0 - handles SIGBUS or EIO
> > =C2=A0 - does a (sector aligned) write() to restore the data
> The "figures out" step here is where >95% of the work we'd have to
> do is. And that's in filesystem and block layer code, not
> userspace, and userspace can't do that work in a signal handler.
> And it=C2=A0=C2=A0can still fall down to the second case when the appli=
cation
> doesn't have another copy of the data somewhere.

Ah when I said "figures out" I was only thinking if the application has
some redundancy/jouranlling, and if it can recover using that -- not
additional recovery mechanisms at the block/fs layer.

>=20
> FWIW, we don't have a DAX enabled filesystem that can do
> reverse block mapping, so we're a year or two away from this being a
> workable production solution from the filesystem perspective. And
> AFAICT, it's not even on the roadmap for dm/md layers.
>=20
> >=20
> > 2. Application doesn't have any inbuilt recovery mechanism
> > =C2=A0 - hits badblock
> > =C2=A0 - gets SIGBUS (or EIO) and crashes
> > =C2=A0 - Sysadmin restores file from backup
> Which is no different to an existing non-DAX application getting an
> EIO/sigbus from current storage technologies.
>=20
> Except: in the existing storage stack, redundancy and correction has
> already had to have failed for the application to see such an error.
> Hence this is normally considered a DR case as there's had to be
> cascading failures (e.g.=C2=A0=C2=A0multiple disk failures in a RAID) t=
o get
> to this stage, not a single error in a single sector in
> non-redundant storage.
>=20
> We need some form of redundancy and correction in the PMEM stack to
> prevent single sector errors from taking down services until an
> administrator can correct the problem. I'm trying to understand
> where this is supposed to fit into the picture - at this point I
> really don't think userspace applications are going to be able to do
> this reliably....

Agreed that the pmem stack could use more redundancy and error
correction, perhaps enabling md-raid to raid pmem devices and then
enable DAX on top of that and we'll have a better chance to handle
errors, but that level of recovery isn't what these patches are aiming
for -- that is obviously a longer term effort. These simply aim to
provide that disaster recovery path when a single sector failure does
take down the service.

Today, on a dax enabled filesystem, if/when the app hits an error and
crashes, dax is simply disabled till the errors are gone. This is
obviously less than ideal. (This was done because there is currently no
way for a DAX file system to send any IO - mmap or otherwise - through
the driver, including zeroing of new fs blocks). These patches enable
the DR path by allowing some non-mmap IO (most importantly zeroing) to
go through the driver which can tell the device to do some remapping
etc.

So, yes, this is very much a DR case in our current pmem+dax
architecture, and we should probably design more robust handling at the
block/md/fs layer, but with these, you at least get to crash the app,
delete its files and restore them from out-of-band backups and continue
with DAX.

>=20
> Cheers,
>=20
> Dave.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
