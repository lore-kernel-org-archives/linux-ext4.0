From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Tue, 7 Dec 2010 15:01:05 -0600
Message-ID: <AANLkTi=4K=qXm1kqKZ=z7W0jnLKQzzh6h0QVGD0YFmYx@mail.gmail.com>
References: <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com> <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
 <20101207142145.GA27861@think> <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
 <20101207182243.GB21112@redhat.com> <20101207193514.GA2921@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>, Mike Snitzer <snitzer@redhat.com>,
	Jon Nelson <jnelson@jamponi.net>,
	Chris Mason <chris.mason@oracle.com>,
	Matt <jackdachef@gmail.com>, Milan Broz <mbroz@r
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f66.google.com ([209.85.214.66]:58922 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab0LGVB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Dec 2010 16:01:27 -0500
In-Reply-To: <20101207193514.GA2921@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 7, 2010 at 1:35 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Dec 07, 2010 at 01:22:43PM -0500, Mike Snitzer wrote:
>> > 1. create a database (from bash):
>> >
>> > createdb test
>> >
>> > 2. place the following contents in a file (I used 't.sql'):
>> >
>> > begin;
>> > create temporary table foo as select x as a, ARRAY[x] as b FROM
>> > generate_series(1, 10000000 ) AS x;
>> > create index foo_a_idx on foo (a);
>> > create index foo_b_idx on foo USING GIN (b);
>> > rollback;
>> >
>> > 3. execute that sql:
>> >
>> > psql -f t.sql --echo-all test
>> >
>> > With 2.6.34.7 I can re-run [3] all day long, as many times as I wa=
nt,
>> > without issue.
>> >
>> > With 2.6.37-rc4-13 (the currently-installed KOTD kernel) if tails
>> > pretty frequently.
>
> So I just tried to reproduce this on an Ubuntu 10.04 system running
> 2.6.37-rc5 (completely stock except for a few apparmor patches that I
> needed to keep the apparmor userspace from complaining). =C2=A0I'm us=
ing
> Postgres 8.4.5-0ubuntu10.04.
>
> Using the above procedure, I wasn't able to reproduce. =C2=A0Then I
> realized this might have been because I was using an SSD root file
> system (which is secured using LUKS/dm-crypt, with LVM on top of
> dm-crypt). =C2=A0So I mounted a file system on a 5400 rpm SSD disk, w=
hich
> is also protected using LUKS/dm-crypt with LVM on top. =C2=A0I then
> executed the PostgresQL commands:
>
> CREATE TABLESPACE test LOCATION '/kbuild/postgres';
> SET default_tablespace =3D test;
> COMMIT
> \quit
>
> I then re-ran the above proceduing, and verified that all of the I/O
> was going to the 5400rpm laptop disk.
>
> I then ran the above procedure a half-dozen times, and I still haven'=
t
> been able to reproduce any Postgresql errors or kernel errors.
>
> Jon, can you help me identify what might be different with your run
> and mine? =C2=A0What version of Postgres are you using?

I am using postgres 8.4.5 on openSUSE 11.3 x86_64.
The problems were observed on both "real" hardware (thinkpad T61p) and
in virtualbox, where all current testing is taking place. The current
kernel is a "vanilla" (unpatched) kernel. I *did* set wal_sync_method
to fdatasync, however, if that is relevant. Otherwise, the pg config
is stock. With no crypt involved, I did have to iterate the tests to
observe the issue - a half-dozen times or more were necessary.
Typically, when crypt was involved, the issue would manifest much more
rapidly.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
