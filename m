From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v3 17/18] ext4: make punch hole code path work with
 bigalloc
Date: Wed, 24 Apr 2013 19:29:04 +0800
Message-ID: <20130424112904.GA3128@gmail.com>
References: <1365498867-27782-1-git-send-email-lczerner@redhat.com>
 <1365498867-27782-18-git-send-email-lczerner@redhat.com>
 <20130420134241.GA2461@quack.suse.cz>
 <20130423091928.GA5321@gmail.com>
 <alpine.LFD.2.00.1304241303560.24669@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1304241303560.24669@localhost>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 24, 2013 at 01:08:17PM +0200, Luk=C3=A1=C5=A1 Czerner wrote:
> On Tue, 23 Apr 2013, Zheng Liu wrote:
[snip]
> > > > Also update respective tracepoints to use signed long long type f=
or
> > > > partial_cluster.
> > >   The patch looks OK. You can add:
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > >=20
> > >   Just a minor nit - sometimes you use 'signed long long', sometime=
s 'long
> > > long int', sometimes just 'long long'. In kernel we tend to always =
use just
> > > 'long long' so it would be good to clean that up.
> >=20
> > Another question is that in patch 01/18 invalidatepage signature is
> > changed from
> >   int (*invalidatepage) (struct page *, unsigned long);
> > to
> >   void (*invalidatepage) (struct page *, unsigned int, unsigned int);
> >=20
> > The argument type is changed from 'unsigned long' to 'unsigned int'. =
 My
> > question is why we need to change it.
> >=20
> > Thanks,
> >                                                 - Zheng
> >=20
>=20
> Hi Zheng,
>=20
> this was changed on Hugh Dickins request because it makes it clearer
> that those args are indeed intended to be offsets within a page
> (0..PAGE_CACHE_SIZE).
>=20
> Even though PAGE_CACHE_SIZE can be defined as unsigned long, this is
> only for convenience. Here is quote from Hugh:
>=20
>   "
>   They would be defined as unsigned long so that they can be used in
>   masks like ~(PAGE_SIZE - 1), and behave as expected on addresses,
>   without needing casts to be added all over.
>=20
>   We do not (currently!) expect PAGE_SIZE or PAGE_CACHE_SIZE to grow
>   beyond an unsigned int - but indeed they can be larger than what's
>   held in an unsigned short (look no further than ia64 or ppc64).
>=20
>   For more reassurance, see include/linux/highmem.h, which declares
>   zero_user_segments() and others: unsigned int (well, unsigned with
>   the int implicit) for offsets within a page.
>=20
>   Hugh
>   "
>=20
> I should probably mention that in the description.

Ah, thanks for your explanation.  I must miss something. :-(

Regards,
                                                - Zheng

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
