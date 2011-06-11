From: Joe Thornber <thornber@redhat.com>
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4
	snapshots)
Date: Sat, 11 Jun 2011 08:35:17 +0100
Message-ID: <20110611073517.GB2517@ubuntu>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
	<BANLkTik20iYN4c9faKD9dzerehazWTwTFw@mail.gmail.com>
	<BANLkTikKRuPu_NX49vr0w-XeN0ZnWo+9vg@mail.gmail.com>
	<alpine.LFD.2.00.1106101101020.4502@dhcp-27-109.brq.redhat.com>
	<20110610101142.GA10144@ubuntu>
	<BANLkTi=0N7QXRvFgjHUJXBi0x=668ahXXA@mail.gmail.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: tytso@mit.edu, Mike Snitzer <snitzer@redhat.com>,
        linux-kernel@vger.kernel.org, lvm-devel@redhat.com,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <lvm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <BANLkTi=0N7QXRvFgjHUJXBi0x=668ahXXA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Sat, Jun 11, 2011 at 08:41:38AM +0300, Amir G. wrote:
> On Fri, Jun 10, 2011 at 1:11 PM, Joe Thornber <thornber@redhat.com> wrote:
> > On Fri, Jun 10, 2011 at 11:01:41AM +0200, Lukas Czerner wrote:
> >> On Fri, 10 Jun 2011, Amir G. wrote:
> >>
> >> > CC'ing lvm-devel and fsdevel
> >> >
> >> >
> >> > On Wed, Jun 8, 2011 at 9:26 PM, Amir G. <amir73il@users.sourceforge.=
net> wrote:
> >> > For the sake of letting everyone understand the differences and trade
> >> > offs between
> >> > LVM and ext4 snapshots, so ext4 snapshots can get a fair trial, I ne=
ed
> >> > to ask you
> >> > some questions about the implementation, which I could not figure ou=
t by myself
> >> > from reading the documents.
> >
> > First up let me say that I'm not intending to support writeable
> > _external_ origins with multisnap. =A0This will come as a suprise to
> > many people, but I don't think we can resolve the dual requirements to
> > efficiently update many, many snapshots when a write occurs _and_ make
> > those snapshots quick to delete (when you're encouraging people to
> > take lots of snapshots performance of delete becomes a real issue).
> >
> =

> If I understand this article correctly:
> http://people.redhat.com/mpatocka/papers/shared-snapshots.pdf
> It says that _external_ origin write updates can be efficient to readonly
> (or not written) snapshots.
> =

> Could you not support readonly snapshots of an _external_ origin?

Yes, that is the intention, and very little work to add.  We just do
something different if the metadata lookup returns -ENODATA.  Above I
said I didn't intend to support _writeable_ external snaps.  Readable
ones are a must, for instance for supporting virtual machine base
images.

> You could even support writable snapshots, that will degrade write
> performance to origin temporarily.
> It can be useful, if one wants to "try-out" mounting a temporary
> writable snapshot, when the origin is not even mounted.
> After the "try-out", the temporary snapshot can be deleted
> and origin write performance would go back to normal.

Not sure what you're getting at here.  All snapshots are writeable.

Of course you can take a snapshot of an external origin and then use
this as your temporary origin for experiments.  If the origin is
itself a dm device then LVM can shuffle tables around to make this
transparent.

The user may want to commit to their experiment at a later time by
merging back to the external origin.  This involves copying, but no
more than a copy-on-write scheme.  Arguably it's better to do the copy
only once we know they want to commit to it.

- Joe

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
