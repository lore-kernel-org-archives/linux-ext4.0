From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 3 Jun 2011 12:06:15 +1000
Message-ID: <20110603020615.GZ561@dastard>
References: <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site>
 <4CE59C9E.6050902@teksavvy.com>
 <1290177488-sup-6540@think>
 <4CE68F80.7000607@teksavvy.com>
 <20101119145748.GB27919@infradead.org>
 <4CE695FF.20601@teksavvy.com>
 <20101207092749.GA26100@infradead.org>
 <1291740643-sup-2494@think>
 <BANLkTimkn7ZVAUJw6NfWVMECfe+C+82i+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Chris Mason <chris.mason@oracle.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Mark Lord <kernel@teksavvy.com>,
	James Bottomley <james.bottomley@suse.de>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	sandeen <sandeen@redhat.com>
To: Kyungmin Park <kmpark@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTimkn7ZVAUJw6NfWVMECfe+C+82i+g@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 02, 2011 at 01:52:12PM +0900, Kyungmin Park wrote:
> On Wed, Dec 8, 2010 at 1:52 AM, Chris Mason <chris.mason@oracle.com> =
wrote:
> > Excerpts from Christoph Hellwig's message of 2010-12-07 04:27:49 -0=
500:
> >> On Fri, Nov 19, 2010 at 10:21:35AM -0500, Mark Lord wrote:
> >> > >I really hate to rely on this third party hearsay (from all sid=
es), and
> >> > >have implement TRIM support in qemu now. =A0I'll soon install w=
in7 and
> >> > >will check out the TRIM patters myself.
> >> >
> >> > Excellent!
> >>
> >> I did a Windows 7 installation under qemu today, and the result is=
:
> >
> > Great, thanks for testing this.
> >
> >>
> >> =A0- it TRIMs the whole device early during the installation
> >> =A0- after that I see a constant stream of small trims during the
> >> =A0 =A0installation. =A0It's using lots of non-contiguous ranges i=
n a single
> >> =A0 =A0TRIM command, with sizes down to 8 sectors (4k) for a singl=
e range.
> >> =A0- after installation there's is some background-trimming going =
on
> >> =A0 =A0even when doing no user interaction with the VM at all.
>=20
> Hi Lukas,
>=20
> Now FITRIM is based on user interaction. So how about to implement th=
e
> AUTO batched discard at kernel level?
> Idea is same as windows, make a single thread and iterate the
> superblocks and call the trim.

Surely this the responsibility of a userspace daemon and a config
file to decide and implement the background trim policy?

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
