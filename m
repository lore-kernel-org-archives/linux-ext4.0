From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Tue, 7 Dec 2010 12:45:14 -0600
Message-ID: <AANLkTikOXjh+D25=7Mzwn7bFN+a9xQSimPHs22q4o2TK@mail.gmail.com>
References: <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com> <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
 <20101207142145.GA27861@think> <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
 <20101207182243.GB21112@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Chris Mason <chris.mason@oracle.com>, Matt <jackdachef@gmail.com>,
	Milan Broz <mbroz@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun@gmail.com,
	linux-ext4@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101207182243.GB21112@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 7, 2010 at 12:22 PM, Mike Snitzer <snitzer@redhat.com> wrot=
e:
> On Tue, Dec 07 2010 at =C2=A01:10pm -0500,
> Jon Nelson <jnelson@jamponi.net> wrote:
>
>> I finally found some time to test this out. With 2.6.37-rc4 (openSUS=
E
>> KOTD kernel) I easily encounter the issue.
>>
>> Using a virtual machine, I created a stock, minimal openSUSE 11.3 x8=
6_64
>> install, installed all updates, installed postgresql and the 'KOTD'
>> (Kernel of the Day)
>> kernel, and ran the following tests (as postgres user because I'm
>> lazy).
>>
>> 1. create a database (from bash):
>>
>> createdb test
>>
>> 2. place the following contents in a file (I used 't.sql'):
>>
>> begin;
>> create temporary table foo as select x as a, ARRAY[x] as b FROM
>> generate_series(1, 10000000 ) AS x;
>> create index foo_a_idx on foo (a);
>> create index foo_b_idx on foo USING GIN (b);
>> rollback;
>>
>> 3. execute that sql:
>>
>> psql -f t.sql --echo-all test
>>
>>
>> With 2.6.34.7 I can re-run [3] all day long, as many times as I want=
,
>> without issue.
>>
>> With 2.6.37-rc4-13 (the currently-installed KOTD kernel) if tails
>> pretty frequently.
>
> How does it fail? =C2=A0postgres errors? =C2=A0kernel errors?

postgresql errors. Typically, header corruption but from the limited
visibility I've had into this via strace, what I see is zeroed pages
where there shouldn't be.

I just ran a test and got:

ERROR:  invalid page header in block 37483 of relation base/16384/16417

but that is not the only error one might get.

>> Then I tested with the 'vanilla' kernel available here:
>>
>> http://download.opensuse.org/repositories/Kernel:/vanilla/standard/
>>
>> The 'vanilla' kernel exhibited the same problems.
>> The version I tested: =C2=A02.6.37-rc4-219-g771f8bc-vanilla.
>>
>> Incidentally, quick tests of jfs, xfs, and ext3 do _not_ show the sa=
me
>> problems, although I will note that I usually saw failure at least 1
>> in 3, but sometimes had to re-run the sql test 4 or 5 times before I
>> saw failure.
>>
>> I will continue to do some testing, but I will hold off on testing t=
he
>> commits above until I receive further testing suggestions.
>
> OK, so to be clear: your testing is on dm-crypt + ext4?

Yes. I took a virtual hard disk which shows up as /dev/sdb, used
cryptsetup to format it as a LUKS volume, mounted the LUKS volume,
formatted as ext4 (or whatever), mounted that, rsync'd over a blank
postgresql 'data' directory, started postgresql, became the postgres
user, and proceeded to create the db and run the sql.

> And you're testing upstream based kernels (meaning the dm-crypt
> scalability patch that has been in question is _not_ in the mix)?

I am testing both the KOTD kernels and the "vanilla" kernels - neither
of which has the dm-crypt patches (as far as I know).

--=20
Jon
