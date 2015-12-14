From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/6] mbcache2: Use referenced bit instead of LRU
Date: Mon, 14 Dec 2015 11:34:00 +0100
Message-ID: <20151214103400.GD8474@quack.suse.cz>
References: <1449683858-28936-1-git-send-email-jack@suse.cz>
 <1449683858-28936-7-git-send-email-jack@suse.cz>
 <CAHpGcM+z=ZakzUC2qHQgOF0ZuDGEfH1HXQwCCruTysOVMEd1zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Laurent GUERBY <laurent@guerby.net>,
	Andreas Dilger <adilger@dilger.ca>
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?=
	<andreas.gruenbacher@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193AbbLNKeD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2015 05:34:03 -0500
Content-Disposition: inline
In-Reply-To: <CAHpGcM+z=ZakzUC2qHQgOF0ZuDGEfH1HXQwCCruTysOVMEd1zw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 12-12-15 00:58:51, Andreas Gr=FCnbacher wrote:
> Jan,
>=20
> 2015-12-09 18:57 GMT+01:00 Jan Kara <jack@suse.cz>:
> > Currently we maintain perfect LRU list by moving entry to the tail =
of
> > the list when it gets used. However these operations on cache-globa=
l
> > list are relatively expensive.
> >
> > In this patch we switch to lazy updates of LRU list. Whenever entry=
 gets
> > used, we set a referenced bit in it. When reclaiming entries, we gi=
ve
> > referenced entries another round in the LRU.
> >
> > In my testing this logic gives about 30% boost to workloads with mo=
stly
> > unique xattr blocks (e.g. xattr-bench with 10 files and 10000 uniqu=
e
> > xattr values).
>=20
> I find it quite confusing that with this patch applied, structs
> mb2_cache and mb2_cache_entry still contain fields with "lru" in thei=
r
> name.

Yes, it's somewhat confusing so if you have a better suggestion for the
name I can change it. Maybe cache_list to suggest it's a list of all
entries in the cache?

BTW, I have kept the name to mirror what we do with inodes which use th=
e
same naming and LRU scheme. But probably there's no strong reason to ad=
here
to the naming scheme.

								Honza
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
