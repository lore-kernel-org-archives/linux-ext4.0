Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45099 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730366AbeKVPqY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Nov 2018 10:46:24 -0500
Received: by mail-ed1-f66.google.com with SMTP id d39so6618525edb.12
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2018 21:08:42 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 3/3] add support to check a journal checksum v1 while
 journal dump.
From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
In-Reply-To: <20181122000749.GF10588@thunk.org>
Date: Thu, 22 Nov 2018 08:08:39 +0300
Cc: linux-ext4@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D42D8C28-FB2D-4881-97D8-7FCC3424D190@gmail.com>
References: <20181119091650.81803-1-alexey.lyashkov@gmail.com>
 <20181119091650.81803-4-alexey.lyashkov@gmail.com>
 <20181122000749.GF10588@thunk.org>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

it=E2=80=99s typical option for Sonexion storages.

journal checksum is enough to cover a corruptions for external journal,=20=

but provide a less overhead than full metadata checksums.
In our=E2=80=99s workload - any checksums is source of huge latency, so =
minimal option had enabled.
from other sides it option can enabled without disk format change.

I was have plan to add v2/v3 checksums to patch series but images need =
to prepared for it.

In this particular usage it was used to find a bug in jbd2 code, with =
back porting commit
de92c8caf16ca84926fa31b7a5590c0fb9c0d5ca
    jbd2: speedup jbd2_journal_get_[write|undo]_access()

to rhel7 code.

that commits introduce a race window while frozen buffer had modified in =
parallel thread.
this race likely to be fixed by
ee57aba159a5c329dc78c181a3ae0549e59f0925
    jbd2: simplify code flow in do_get_write_access()

which described as cleanup.


> 22 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3., =D0=B2 3:07, Theodore Y. =
Ts'o <tytso@mit.edu> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>=20
> On Mon, Nov 19, 2018 at 12:16:50PM +0300, alexey.lyashkov@gmail.com =
wrote:
>>=20
>> journal checksum v1 cover an all blocks in journal descriptor.
>> This checksum stored into commit block and check with commit
>> block reading.
>=20
> I'm really curious --- why do you care about journal_checksum v1 at
> all?  It rarely used, and the journal_checksum v3 is much superior.
>=20
>      	 	       	     	     		      - Ted
> 						     =20
