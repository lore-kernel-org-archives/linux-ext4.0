From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Thu, 9 Dec 2010 12:10:58 -0600
Message-ID: <AANLkTimAUB5L5Ptm4Fv=sQUmL9_P5azPRCKQnmU89xs8@mail.gmail.com>
References: <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com> <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
 <20101207142145.GA27861@think> <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
 <20101207182243.GB21112@redhat.com> <20101207193514.GA2921@thunk.org>
 <AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com> <20101209180111.GF2921@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>, Jon Nelson <jnelson@jamponi.net>,
	Mike Snitzer <snitzer@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Matt <jackdachef@gmail.com>, Milan Broz <mbroz@r
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:37075 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab0LISLU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Dec 2010 13:11:20 -0500
In-Reply-To: <20101209180111.GF2921@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 9, 2010 at 12:01 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Dec 07, 2010 at 09:37:20PM -0600, Jon Nelson wrote:
>> One difference is the location of the transaction logs (pg_xlog). In
>> my case, /var/lib/pgsql/data *is* mountpoint for the test volume
>> (actually, it's a symlink to the mount point). In your case, that is
>> not so. Perhaps that makes a difference? =C2=A0pgsql_tmp might also =
be on
>> two different volumes in your case (I can't be sure).
>
> I just tried tried to run t.sql five times with /var/lib/postgres as =
a
> mountpoint for a 5400 rpm disk, and I still haven't been able to
> replicate it.

You should be OK, there. Are you using encryption or no?
I had difficulty replicating the issue without encryption.

> If you can point out how to query pgsql_tmp (I'm using a completely
> default postgres install), that would be helpful, but I don't think i=
t
> would be going anywhere else.

Normally it's /var/lib/pgsql/data/pgsql_tmp (or
/var/lib/postgres/data/pgsql_tmp in your case). By placing
/var/lib/{postgresql,pgsql}/data on the LUKS + ext4 volume, on both
openSUSE 11.3 and Kubuntu, I was able to replicate the problem easily,
in VirtualBox. I can give qemu a try. In both cases I was using a
2.6.37x kernel.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
