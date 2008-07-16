From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH, RFC] Add more intelligent handling of the mke2fs.conf
	installation process
Date: Wed, 16 Jul 2008 11:24:36 -0700
Message-ID: <1216232676.6424.18.camel@mingming-laptop>
References: <E1KITeX-0001PV-Pv@closure.thunk.org>
	 <487BAA6B.7030001@redhat.com> <20080714195526.GA3382@mit.edu>
	 <1216172323.8292.23.camel@mingming-laptop> <20080716023532.GO8185@mit.edu>
	 <1216227720.6424.7.camel@mingming-laptop>  <20080716175257.GF2167@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36117 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbYGPSYh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jul 2008 14:24:37 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6GIObE9013545
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 14:24:37 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6GIObxl207324
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 14:24:37 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6GIOaBP000541
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 14:24:37 -0400
In-Reply-To: <20080716175257.GF2167@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-16=E4=B8=89=E7=9A=84 13:52 -0400=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A
> On Wed, Jul 16, 2008 at 10:02:00AM -0700, Mingming Cao wrote:
> > I looked at misc/Makefile, it seems if the system already
> > have /etc/mke2fs.conf, it will not get updated. This is reasonable =
for
> > ext3.   But not good for ext4.
>=20
> Good point.  The following patch won't do anything for people buildin=
g
> RPM or dpkg packages (which have their own automatic configuration
> file handling); this will provide a poor person's config handling
> machinery for people building e2fsprogs and the installing on their
> own local system.
>=20

Thanks Ted,=20

I verified it works great.

Mingming
> 						- Ted
>=20
> From f8e42224f8cc77afd2b2372dc527428072e28519 Mon Sep 17 00:00:00 200=
1
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Wed, 16 Jul 2008 13:39:32 -0400
> Subject: [PATCH] Add more intelligent handling of the mke2fs.conf ins=
tallation process
>=20
> For people who are compiling mke2fs for their own use outside of a
> package manager, we need to make sure the system /etc/mke2fs.conf is
> sufficiently up-to-date that it won't cause problems, but at the same
> time we don't want to blow away any user-specific customizations.
>=20
> So if /etc/mk2fs.conf exists, but does not mention ext4dev, we will
> move it aside to /etc/mke2fs.conf.e2fsprogs-old and then install the
> new mke2fs.conf.  If the /etc/mke2fs.conf file exists but does mentio=
n
> ext4dev, we install the new mke2fs.conf file as
> /etc/mke2fs.conf.e2fsprogs-new.  In both we print warning to the user
> so they can manually make any changes as needed.
>=20
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  misc/Makefile.in |   25 ++++++++++++++++++++++++-
>  1 files changed, 24 insertions(+), 1 deletions(-)
>=20
> diff --git a/misc/Makefile.in b/misc/Makefile.in
> index a8d1018..a81df8a 100644
> --- a/misc/Makefile.in
> +++ b/misc/Makefile.in
> @@ -343,7 +343,30 @@ install: all $(SMANPAGES) $(UMANPAGES) installdi=
rs
>  		echo "	INSTALL_DATA $(man5dir)/$$i"; \
>  		$(INSTALL_DATA) $$i $(DESTDIR)$(man5dir)/$$i; \
>  	done
> -	@if ! test -f $(DESTDIR)$(root_sysconfdir)/mke2fs.conf; then \
> +	@if test -f $(DESTDIR)$(root_sysconfdir)/mke2fs.conf; then \
> +		if cmp -s $(DESTDIR)$(root_sysconfdir)/mke2fs.conf \
> +			$(srcdir)/mke2fs.conf; then \
> +			true; \
> +		else \
> +			if grep -q ext4dev $(DESTDIR)$(root_sysconfdir)/mke2fs.conf ; the=
n \
> +				echo "	INSTALL_DATA $(root_sysconfdir)/mke2fs.conf.e2fsprogs-new=
"; \
> +				$(INSTALL_DATA) $(srcdir)/mke2fs.conf \
> +					$(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-new; \
> +				echo "Warning: installing mke2fs.conf in $(DESTDIR)$(root_syscon=
fdir)/mke2fs.conf.e2fsprogs-new"; \
> +				echo "Check to see if you need to update your $(root_sysconfdir)=
/mke2fs.conf"; \
> +			else \
> +				echo "	INSTALL_DATA $(root_sysconfdir)/mke2fs.conf"; \
> +				mv $(DESTDIR)$(root_sysconfdir)/mke2fs.conf \
> +				   $(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-old; \
> +				$(INSTALL_DATA) $(srcdir)/mke2fs.conf \
> +					$(DESTDIR)$(root_sysconfdir)/mke2fs.conf; \
> +				echo "Your mke2fs.conf is too old.  Backing up old version in"; =
\
> +				echo "$(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-old.  P=
lease check to see"; \
> +				echo "if you have any local customizations that you wish to pres=
erve."; \
> +			fi; \
> +			echo " "; \
> +		fi; \
> +	else \
>  		echo "	INSTALL_DATA $(root_sysconfdir)/mke2fs.conf"; \
>  		$(INSTALL_DATA) $(srcdir)/mke2fs.conf \
>  			$(DESTDIR)$(root_sysconfdir)/mke2fs.conf; \

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
