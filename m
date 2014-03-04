From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: warning in ext4_journal_start_sb on filesystem freeze
Date: Tue, 4 Mar 2014 11:43:06 -0500
Message-ID: <20140304164306.GC12805@fieldses.org>
References: <217983071.143460.1385453196946.JavaMail.zimbra@rapitasystems.com>
 <1697998867.143517.1385454051031.JavaMail.zimbra@rapitasystems.com>
 <20131126125826.GA4503@quack.suse.cz>
 <622177618.727.1393062606061.JavaMail.zimbra@rapitasystems.com>
 <20140224095525.GA20532@quack.suse.cz>
 <20140224154532.GB11992@fieldses.org>
 <20140225102126.GB1669@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Matthew Rahtz <mrahtz-lFL+a/sBLVi/3pe1ocb+swC/G2K4zDHf@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140225102126.GB1669-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 25, 2014 at 11:21:26AM +0100, Jan Kara wrote:
> On Mon 24-02-14 10:45:32, J. Bruce Fields wrote:
> > On Mon, Feb 24, 2014 at 10:55:25AM +0100, Jan Kara wrote:
> > > On Sat 22-02-14 09:50:06, Matthew Rahtz wrote:
> > > > Thanks for your help Jan,
> > > >=20
> > > > A few months later, we've noticed the issue is actually still t=
here.
> > > > Using 3.11.0-17-generic on Ubuntu 12.04, we=E2=80=99re seeing t=
his in the kernel
> > > > logs:
> > > >=20
> > > > [29243.606215] WARNING: CPU: 0 PID: 1785 at
> > > > /build/buildd/linux-lts-saucy-3.11.0/fs/ext4/ext4_jbd2.c:48
> > > > ext4_journal_check_start+0x83/0x90()
> > > >=20
> > > > Having a look at the Ubuntu source package for that version, it
> > > > definitely does include commit 03d95eb2f2578083a3f6286262e1cb5d=
88a00c02,
> > > > and the line generating the warning is still:
> > > >=20
> > > > WARN_ON(sb->s_writers.frozen =3D=3D SB_FREEZE_COMPLETE);
> > > >=20
> > > > Are there any other obvious possibilities for what may be causi=
ng this?
> > > > There seem to be some users of Oracle Linux experiencing simila=
r problems
> > > > at https://community.oracle.com/thread/2617418, which was appar=
ently
> > > > fixed in Oracle's kernel version '3.8.13-26.el6uek'. Any word o=
n when
> > > > this might be integrated into the official kernel?
> > > >=20
> > > > Full call trace included below.
> > >   Looking at the trace below, now the problem seems to be in the =
NFS server
> > > code. NFS should get protection against the filesystem being froz=
en (or
> > > remounted read-only for that matter) via mnt_want_write() before =
calling
> > > into notify_change() (actually before calling fh_lock() because o=
f lock
> > > ordering).  Similarly to what we do e.g. in fchownat(). Bruce?
> >=20
> > Like this?
>   Yup, that looks right.

Ugh, actually, I didn't realize we can't do mnt_want_write recursively,
and there's a confusing mixture of callers that do and don't already
take it, so I'll have to do something a little more complicated.

Oh well.--b.

>=20
> > But I wonder why this is just popping up now--as far as I can tell =
we've
> > had the bug since those write counts were introduced.
>   Yeah, I'm wondering as well. NFS server on ext4 should have been
> complaining for a long time.
>=20
> 								Honza
>=20
> > diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> > index 6d7be3f..d573b61 100644
> > --- a/fs/nfsd/vfs.c
> > +++ b/fs/nfsd/vfs.c
> > @@ -445,12 +445,16 @@ nfsd_setattr(struct svc_rqst *rqstp, struct s=
vc_fh *fhp, struct iattr *iap,
> >  		err =3D nfserr_notsync;
> >  		goto out_put_write_access;
> >  	}
> > +	host_err =3D fh_want_write(fhp);
> > +	if (host_err)
> > +		goto out_nfserr;
> > =20
> >  	fh_lock(fhp);
> >  	host_err =3D notify_change(dentry, iap, NULL);
> >  	fh_unlock(fhp);
> > +	fh_drop_write(fhp);
> > +out_nfserr:
> >  	err =3D nfserrno(host_err);
> > -
> >  out_put_write_access:
> >  	if (size_change)
> >  		put_write_access(inode);
> --=20
> Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
