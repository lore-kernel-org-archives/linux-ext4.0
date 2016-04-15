From: Toshi Kani <toshi.kani@hpe.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Fri, 15 Apr 2016 13:08:28 -0600
Message-ID: <1460747308.4597.9.camel@hpe.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	 <1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	 <x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	 <1460739288.3012.3.camel@intel.com>
	 <x49potq6bm2.fsf@segfault.boston.devel.redhat.com>
	 <1460741821.3012.11.camel@intel.com>
	 <CAPcyv4hemNM4uQYCPBXyH+DWTOLvyBNBeMYstKbPdad_Cw48HQ@mail.gmail.com>
	 <x49lh4e6928.fsf@segfault.boston.devel.redhat.com>
	 <CAPcyv4hRQj2ZsFj7Xa_=OwcHrzP9_5yUpt3LQ+bPH4PcLe7UCQ@mail.gmail.com>
	 <1460746909.4597.7.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>,
 "david@fromorbit.com" <david@fromorbit.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
 "hch@infradead.org" <hch@infradead.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>,  "linux-block@vger.kernel.org"
 <linux-block@vger.kernel.org>, "viro@zeniv.linux.org.uk"
 <viro@zeniv.linux.org.uk>, "linux-nvdimm@ml01.01.org"
 <linux-nvdimm@ml01.01.org>,  "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org"
 <linux-ext4@vger.kernel.org>, "Wilcox, Matthew R"
 <matthew.r.wilcox@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1460746909.4597.7.camel@hpe.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2016-04-15 at 13:01 -0600, Toshi Kani wrote:
> On Fri, 2016-04-15 at 11:17 -0700, Dan Williams wrote:
> >=20
> > On Fri, Apr 15, 2016 at 11:06 AM, Jeff Moyer <jmoyer@redhat.com> wrot=
e:
> > >=20
> > > Dan Williams <dan.j.williams@intel.com> writes:
> > > =C2=A0
> > > > > > There's a lot of special casing here, so you might consider
> > > > > > adding comments.
> > > > > Correct - maybe we should reconsider wrapper-izing this? :)
> > > > Another option is just to skip dax_do_io() and this special casin=
g
> > > > fallback entirely if errors are present.=C2=A0=C2=A0I.e. only att=
empt
> > > > dax_do_io when: IS_DAX() && gendisk->bb && bb->count =3D=3D 0.
> > >
> > > So, if there's an error anywhere on the device, penalize all I/O (n=
ot
> > > just writes, and not just on sectors that are bad)?=C2=A0=C2=A0I'm =
not sure
> > > that's a great plan, either.
> > >=20
> > If errors are rare how much are we actually losing in practice?
> > Moreover, we're going to do the full badblocks lookup anyway when we
> > call ->direct_access().=C2=A0=C2=A0If we had that information earlier=
 we can
> > avoid this fallback dance.
>
> A system running with DAX may have active data set in NVDIMM lager than
> RAM size. =C2=A0In this case, falling back to non-DAX will allocate pag=
e cache
> for the data, which will saturate the system with memory pressure.

Oh, sorry, we are still in DIO path. =C2=A0Falling back to DIO should not=
 cause
this issue.

-Toshi

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
