From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: PATCH - e2fsprogs - rename static variable link
Date: Tue, 29 Apr 2014 08:24:17 -0700
Message-ID: <20140429152417.GB17247@birch.djwong.org>
References: <535F6B36.70401@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Martin =?utf-8?B?TGnFoWth?= <mliska@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17507 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaD2PYW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Apr 2014 11:24:22 -0400
Content-Disposition: inline
In-Reply-To: <535F6B36.70401@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 29, 2014 at 11:04:54AM +0200, Martin Li=C5=A1ka wrote:
> Hello,
>    I've been testing gentoo packages: http://marxin.github.io/blog/20=
14/04/24/gentoo-linux-packages-with-gcc-4-dot-9-lto/
> and I met few gentoo packages that have conflicting variable with
> compile_et:
>=20
> https://github.com/krb5/krb5/issues/106
>=20
> I would like to ask you if you can apply attached patch. It's
> suggestion, maybe you will find better variable name.
>=20
> Compiles fine for x86_64, test suite passes.

Looks ok to me, but you should add a Signed-off-by: and send to
linux-ext4@vger.kernel.org [cc'd] so Ted can have a look and possibly a=
pply it.
It's sort of surprising that LTO can't deal with a static variable that=
 shadows
a global symbol, but then I haven't looked at LTO.

--D

>=20
> Thank you,
> Martin

> diff --git a/lib/et/et_c.awk b/lib/et/et_c.awk
> index 99c33ba..8680279 100644
> --- a/lib/et/et_c.awk
> +++ b/lib/et/et_c.awk
> @@ -238,7 +238,7 @@ END {
>  		tab_base_low, table_item_count) > outfile
>  	}
>  	print "" > outfile
> -	print "static struct et_list link =3D { 0, 0 };" > outfile
> +	print "static struct et_list link_ =3D { 0, 0 };" > outfile
>  	print "" > outfile
>  	print "void initialize_" table_name "_error_table_r(struct et_list =
**list);" > outfile
>  	print "void initialize_" table_name "_error_table(void);" > outfile
> @@ -257,8 +257,8 @@ END {
>  	print "            return;" > outfile
>  	print "    et =3D malloc(sizeof(struct et_list));" > outfile
>  	print "    if (et =3D=3D 0) {" > outfile
> -	print "        if (!link.table)" > outfile
> -	print "            et =3D &link;" > outfile
> +	print "        if (!link_.table)" > outfile
> +	print "            et =3D &link_;" > outfile
>  	print "        else" > outfile
>  	print "            return;" > outfile
>  	print "    }" > outfile
> diff --git a/lib/et/test_cases/continuation.c b/lib/et/test_cases/con=
tinuation.c
> index 1207897..1e17ba4 100644
> --- a/lib/et/test_cases/continuation.c
> +++ b/lib/et/test_cases/continuation.c
> @@ -25,7 +25,7 @@ extern struct et_list *_et_list;
> =20
>  const struct error_table et_ovk_error_table =3D { text, 43787520L, 1=
 };
> =20
> -static struct et_list link =3D { 0, 0 };
> +static struct et_list link_ =3D { 0, 0 };
> =20
>  void initialize_ovk_error_table_r(struct et_list **list);
>  void initialize_ovk_error_table(void);
> @@ -44,8 +44,8 @@ void initialize_ovk_error_table_r(struct et_list **=
list)
>              return;
>      et =3D malloc(sizeof(struct et_list));
>      if (et =3D=3D 0) {
> -        if (!link.table)
> -            et =3D &link;
> +        if (!link_.table)
> +            et =3D &link_;
>          else
>              return;
>      }
> diff --git a/lib/et/test_cases/heimdal.c b/lib/et/test_cases/heimdal.=
c
> index d9be4ce..192c9bb 100644
> --- a/lib/et/test_cases/heimdal.c
> +++ b/lib/et/test_cases/heimdal.c
> @@ -106,7 +106,7 @@ extern struct et_list *_et_list;
> =20
>  const struct error_table et_krb_error_table =3D { text, 39525376L, 8=
2 };
> =20
> -static struct et_list link =3D { 0, 0 };
> +static struct et_list link_ =3D { 0, 0 };
> =20
>  void initialize_krb_error_table_r(struct et_list **list);
>  void initialize_krb_error_table(void);
> @@ -125,8 +125,8 @@ void initialize_krb_error_table_r(struct et_list =
**list)
>              return;
>      et =3D malloc(sizeof(struct et_list));
>      if (et =3D=3D 0) {
> -        if (!link.table)
> -            et =3D &link;
> +        if (!link_.table)
> +            et =3D &link_;
>          else
>              return;
>      }
> diff --git a/lib/et/test_cases/heimdal2.c b/lib/et/test_cases/heimdal=
2.c
> index a8d4c11..ec5b646 100644
> --- a/lib/et/test_cases/heimdal2.c
> +++ b/lib/et/test_cases/heimdal2.c
> @@ -92,7 +92,7 @@ extern struct et_list *_et_list;
> =20
>  const struct error_table et_kadm_error_table =3D { text, -1783126272=
L, 68 };
> =20
> -static struct et_list link =3D { 0, 0 };
> +static struct et_list link_ =3D { 0, 0 };
> =20
>  void initialize_kadm_error_table_r(struct et_list **list);
>  void initialize_kadm_error_table(void);
> @@ -111,8 +111,8 @@ void initialize_kadm_error_table_r(struct et_list=
 **list)
>              return;
>      et =3D malloc(sizeof(struct et_list));
>      if (et =3D=3D 0) {
> -        if (!link.table)
> -            et =3D &link;
> +        if (!link_.table)
> +            et =3D &link_;
>          else
>              return;
>      }
> diff --git a/lib/et/test_cases/heimdal3.c b/lib/et/test_cases/heimdal=
3.c
> index b8b9b73..4ffbb1b 100644
> --- a/lib/et/test_cases/heimdal3.c
> +++ b/lib/et/test_cases/heimdal3.c
> @@ -26,7 +26,7 @@ extern struct et_list *_et_list;
> =20
>  const struct error_table et_h3test_error_table =3D { text, 43787520L=
, 2 };
> =20
> -static struct et_list link =3D { 0, 0 };
> +static struct et_list link_ =3D { 0, 0 };
> =20
>  void initialize_h3test_error_table_r(struct et_list **list);
>  void initialize_h3test_error_table(void);
> @@ -45,8 +45,8 @@ void initialize_h3test_error_table_r(struct et_list=
 **list)
>              return;
>      et =3D malloc(sizeof(struct et_list));
>      if (et =3D=3D 0) {
> -        if (!link.table)
> -            et =3D &link;
> +        if (!link_.table)
> +            et =3D &link_;
>          else
>              return;
>      }
> diff --git a/lib/et/test_cases/imap_err.c b/lib/et/test_cases/imap_er=
r.c
> index 6f576d3..ca5414e 100644
> --- a/lib/et/test_cases/imap_err.c
> +++ b/lib/et/test_cases/imap_err.c
> @@ -54,7 +54,7 @@ extern struct et_list *_et_list;
> =20
>  const struct error_table et_imap_error_table =3D { text, -1904809472=
L, 30 };
> =20
> -static struct et_list link =3D { 0, 0 };
> +static struct et_list link_ =3D { 0, 0 };
> =20
>  void initialize_imap_error_table_r(struct et_list **list);
>  void initialize_imap_error_table(void);
> @@ -73,8 +73,8 @@ void initialize_imap_error_table_r(struct et_list *=
*list)
>              return;
>      et =3D malloc(sizeof(struct et_list));
>      if (et =3D=3D 0) {
> -        if (!link.table)
> -            et =3D &link;
> +        if (!link_.table)
> +            et =3D &link_;
>          else
>              return;
>      }
> diff --git a/lib/et/test_cases/simple.c b/lib/et/test_cases/simple.c
> index 10ab1a3..76b64ec 100644
> --- a/lib/et/test_cases/simple.c
> +++ b/lib/et/test_cases/simple.c
> @@ -46,7 +46,7 @@ extern struct et_list *_et_list;
> =20
>  const struct error_table et_krb_error_table =3D { text, 39525376L, 2=
2 };
> =20
> -static struct et_list link =3D { 0, 0 };
> +static struct et_list link_ =3D { 0, 0 };
> =20
>  void initialize_krb_error_table_r(struct et_list **list);
>  void initialize_krb_error_table(void);
> @@ -65,8 +65,8 @@ void initialize_krb_error_table_r(struct et_list **=
list)
>              return;
>      et =3D malloc(sizeof(struct et_list));
>      if (et =3D=3D 0) {
> -        if (!link.table)
> -            et =3D &link;
> +        if (!link_.table)
> +            et =3D &link_;
>          else
>              return;
>      }

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
