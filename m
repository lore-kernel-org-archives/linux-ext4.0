From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: warning in ext4_journal_start_sb on filesystem freeze
Date: Mon, 24 Feb 2014 10:45:32 -0500
Message-ID: <20140224154532.GB11992@fieldses.org>
References: <217983071.143460.1385453196946.JavaMail.zimbra@rapitasystems.com>
 <1697998867.143517.1385454051031.JavaMail.zimbra@rapitasystems.com>
 <20131126125826.GA4503@quack.suse.cz>
 <622177618.727.1393062606061.JavaMail.zimbra@rapitasystems.com>
 <20140224095525.GA20532@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Matthew Rahtz <mrahtz-lFL+a/sBLVi/3pe1ocb+swC/G2K4zDHf@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140224095525.GA20532-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Feb 24, 2014 at 10:55:25AM +0100, Jan Kara wrote:
> On Sat 22-02-14 09:50:06, Matthew Rahtz wrote:
> > Thanks for your help Jan,
> >=20
> > A few months later, we've noticed the issue is actually still there=
=2E
> > Using 3.11.0-17-generic on Ubuntu 12.04, we=E2=80=99re seeing this =
in the kernel
> > logs:
> >=20
> > [29243.606215] WARNING: CPU: 0 PID: 1785 at
> > /build/buildd/linux-lts-saucy-3.11.0/fs/ext4/ext4_jbd2.c:48
> > ext4_journal_check_start+0x83/0x90()
> >=20
> > Having a look at the Ubuntu source package for that version, it
> > definitely does include commit 03d95eb2f2578083a3f6286262e1cb5d88a0=
0c02,
> > and the line generating the warning is still:
> >=20
> > WARN_ON(sb->s_writers.frozen =3D=3D SB_FREEZE_COMPLETE);
> >=20
> > Are there any other obvious possibilities for what may be causing t=
his?
> > There seem to be some users of Oracle Linux experiencing similar pr=
oblems
> > at https://community.oracle.com/thread/2617418, which was apparentl=
y
> > fixed in Oracle's kernel version '3.8.13-26.el6uek'. Any word on wh=
en
> > this might be integrated into the official kernel?
> >=20
> > Full call trace included below.
>   Looking at the trace below, now the problem seems to be in the NFS =
server
> code. NFS should get protection against the filesystem being frozen (=
or
> remounted read-only for that matter) via mnt_want_write() before call=
ing
> into notify_change() (actually before calling fh_lock() because of lo=
ck
> ordering).  Similarly to what we do e.g. in fchownat(). Bruce?

Like this?

But I wonder why this is just popping up now--as far as I can tell we'v=
e
had the bug since those write counts were introduced.

--b.

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 6d7be3f..d573b61 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -445,12 +445,16 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_f=
h *fhp, struct iattr *iap,
 		err =3D nfserr_notsync;
 		goto out_put_write_access;
 	}
+	host_err =3D fh_want_write(fhp);
+	if (host_err)
+		goto out_nfserr;
=20
 	fh_lock(fhp);
 	host_err =3D notify_change(dentry, iap, NULL);
 	fh_unlock(fhp);
+	fh_drop_write(fhp);
+out_nfserr:
 	err =3D nfserrno(host_err);
-
 out_put_write_access:
 	if (size_change)
 		put_write_access(inode);
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
