From: Vishal Verma <vishal@kernel.org>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Tue, 26 Apr 2016 09:01:32 -0600
Message-ID: <1461682892.26226.23.camel@kernel.org>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	 <1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	 <x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	 <20160420205923.GA24797@infradead.org> <1461434916.3695.7.camel@intel.com>
	 <20160425083114.GA27556@infradead.org> <1461604476.3106.12.camel@intel.com>
	 <20160426083332.GB364@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "xfs@oss.sgi.com" <xfs@oss.sgi.com>,  "linux-nvdimm@ml01.01.org"
 <linux-nvdimm@ml01.01.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "viro@zeniv.linux.org.uk"
 <viro@zeniv.linux.org.uk>,  "axboe@fb.com" <axboe@fb.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 "david@fromorbit.com" <david@fromorbit.com>,  "jack@suse.cz" <jack@suse.cz>
To: "hch@infradead.org" <hch@infradead.org>, "Verma, Vishal L"
	 <vishal.l.verma@intel.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160426083332.GB364@infradead.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2016-04-26 at 01:33 -0700, hch@infradead.org wrote:
> On Mon, Apr 25, 2016 at 05:14:36PM +0000, Verma, Vishal L wrote:
> >=20
> > - Application hits EIO doing dax_IO or load/store io
> >=20
> > - It checks badblocks and discovers it's files have lost data
> >=20
> > - It write()s those sectors (possibly converted to file offsets
> > using
> > fiemap)
> > ?? ?? * This triggers the fallback path, but if the application is
> > doing
> > this level of recovery, it will know the sector is bad, and write
> > the
> > entire sector
> This sounds like a mess.
>=20
> >=20
> > I think if we want to keep allowing arbitrary alignments for the
> > dax_do_io path, we'd need:
> > 1. To represent badblocks at a finer granularity (likely cache
> > lines)
> > 2. To allow the driver to do IO to a *block device* at sub-sector
> > granularity
> It's not a block device if it supports DAX.=C2=A0=C2=A0It's byte addres=
sable
> memory masquerading as a block device.

Yes but we made that decision a while back with pmem :)
Are you saying it should stop being a block device anymore?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-info=
.html

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
