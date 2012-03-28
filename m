From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Wed, 28 Mar 2012 11:44:42 +0300
Message-ID: <1332924282.31549.51.camel@sauron.fi.intel.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
	 <20120322095342.GC14485@quack.suse.cz>
	 <1332410747.18717.12.camel@sauron.fi.intel.com>
	 <20120322103309.GA14484@quack.suse.cz>
	 <1332854998.31549.40.camel@sauron.fi.intel.com>
	 <20120327201401.GF5020@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3KYVoE89Y+OMF7K4ujD+"
Cc: Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57224 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005Ab2C1ImS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Mar 2012 04:42:18 -0400
In-Reply-To: <20120327201401.GF5020@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-3KYVoE89Y+OMF7K4ujD+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the patches.

On Tue, 2012-03-27 at 22:14 +0200, Jan Kara wrote:
> @@ -181,9 +181,22 @@ static int ext4_file_open(struct inode * inode, stru=
ct file * filp)
>                 path.dentry =3D mnt->mnt_root;
>                 cp =3D d_path(&path, buf, sizeof(buf));
>                 if (!IS_ERR(cp)) {
> +                       handle_t *handle;
> +                       int err;
> +
> +                       handle =3D ext4_journal_start_sb(sb, 1);
> +                       if (IS_ERR(handle))
> +                               return PTR_ERR(handle);
> +                       err =3D ext4_journal_get_write_access(handle,
> +                                                           EXT4_SB(sb)->=
s_sbh);

Why do we need to bother with journal in this case - AFAIU, we update a
single field, not critical, and we do not really need the journal for
this - we can just call 'mark_buffer_dirty(sbi->s_sbh)' and let the SB
be written out directly and asynchronously.

--=20
Best Regards,
Artem Bityutskiy

--=-3KYVoE89Y+OMF7K4ujD+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPcs96AAoJECmIfjd9wqK0q1sP/38MOoiqRN4TEnKk7Bdij6qC
oz44mvkaoeta0KTE+NxZ9oIrl57VzAGkZBj5Fmb+ch5T/be47EjSDSHxu/0cbrdj
HSQeYwZfQQiD0datJsGtCYJNfV0h9FvOPXsZLeAZHBpfUskEX5VIf4XGgFlLGBii
juMc56JHvHTdyHC6NJ0eJSu1DTXanhRUdL3YA8++YIOZ6Rmml1u7SBAdNNgkz6Jb
4dh8NwR5sR9kmBmx3PNBj6IqUaxIJTZs5PLpQ4L1LQYHMFJ7gg3o/7ZF5pebAxpw
6m5S108xDrL+hELqVduryE8cWA6EWaJEYrzvOFCWfpr0+BU1niGFbTSP7UIqs1qC
4co5nTswK1UtJ9zQCQrGMgKFPNU8e2tGl1QBiwtqQCiX1+frZPF8Z9mw14i3N+7v
BtG1CwAMw1h9PO/3y2PdXR4LB7l8QPa2N38l6+nILdb6pZrpDLljYGRJEa/+IiJj
wv+d/wUbLVxu0dmzr729Jfvc9W0iSchr+qE0roseP+0pUaka5/sHedjsJA6bKBt0
6xA+fvGuM7AIvFLO9rzdV1XPi/IZXZqUSuqEP1nxBHpWPjIUAF0BKbpVjanRV7Uk
gQ4aq2mKl3XnSvdB82jUgZsOeV4mpbpHKlQEhkArCaRvHRQzW2E2lw5B7ec/y+DR
Fzo2DU2G1n6hul9BwCD5
=c5BY
-----END PGP SIGNATURE-----

--=-3KYVoE89Y+OMF7K4ujD+--

