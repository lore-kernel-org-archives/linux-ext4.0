From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/7] dax: New fault locking
Date: Thu, 19 May 2016 11:27:02 +0200
Message-ID: <20160519092702.GB19697@quack2.suse.cz>
References: <1463070560-1979-1-git-send-email-jack@suse.cz>
 <1463070560-1979-6-git-send-email-jack@suse.cz>
 <20160512193624.GA20719@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org,
	Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677AbcESJ1F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 May 2016 05:27:05 -0400
Content-Disposition: inline
In-Reply-To: <20160512193624.GA20719@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 12-05-16 13:36:24, Ross Zwisler wrote:
> On Thu, May 12, 2016 at 06:29:18PM +0200, Jan Kara wrote:
> > @@ -897,13 +1166,10 @@ int __dax_pmd_fault(struct vm_area_struct *v=
ma, unsigned long address,
> >  		 * the write to insert a dirty entry.
> >  		 */
> >  		if (write) {
> > -			error =3D dax_radix_entry(mapping, pgoff, dax.sector,
> > -					true, true);
> > -			if (error) {
> > -				dax_pmd_dbg(&bh, address,
> > -						"PMD radix insertion failed");
> > -				goto fallback;
> > -			}
> > +			/*
> > +			 * We should insert radix-tree entry and dirty it here.
> > +			 * For now this is broken...
> > +			 */
>=20
> With this change the 'error' variable in __dax_pmd_fault() is now unu=
sed,
> resulting in a compiler warning.
>=20
> fs/dax.c: In function =E2=80=98__dax_pmd_fault=E2=80=99:
> fs/dax.c:1019:6: warning: unused variable =E2=80=98error=E2=80=99 [-W=
unused-variable]
>   int error, result =3D 0;
>         ^

I didn't want to respin the patch set because of this but I'll send a f=
ixup
patch for it.

								Honza
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
