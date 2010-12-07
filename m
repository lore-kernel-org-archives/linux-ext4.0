From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Tue, 7 Dec 2010 13:22:43 -0500
Message-ID: <20101207182243.GB21112@redhat.com>
References: <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com>
 <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com>
 <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com>
 <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
 <20101207142145.GA27861@think>
 <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, Matt <jackdachef@gmail.com>,
	Milan Broz <mbroz@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun@gmail.com,
	linux-ext4@vger.kernel.org
To: Jon Nelson <jnelson@jamponi.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab0LGSXB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Dec 2010 13:23:01 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 07 2010 at  1:10pm -0500,
Jon Nelson <jnelson@jamponi.net> wrote:

> I finally found some time to test this out. With 2.6.37-rc4 (openSUSE
> KOTD kernel) I easily encounter the issue.
> 
> Using a virtual machine, I created a stock, minimal openSUSE 11.3 x86_64
> install, installed all updates, installed postgresql and the 'KOTD'
> (Kernel of the Day)
> kernel, and ran the following tests (as postgres user because I'm
> lazy).
> 
> 1. create a database (from bash):
> 
> createdb test
> 
> 2. place the following contents in a file (I used 't.sql'):
> 
> begin;
> create temporary table foo as select x as a, ARRAY[x] as b FROM
> generate_series(1, 10000000 ) AS x;
> create index foo_a_idx on foo (a);
> create index foo_b_idx on foo USING GIN (b);
> rollback;
> 
> 3. execute that sql:
> 
> psql -f t.sql --echo-all test
> 
> 
> With 2.6.34.7 I can re-run [3] all day long, as many times as I want,
> without issue.
> 
> With 2.6.37-rc4-13 (the currently-installed KOTD kernel) if tails
> pretty frequently.

How does it fail?  postgres errors?  kernel errors?
 
> Then I tested with the 'vanilla' kernel available here:
> 
> http://download.opensuse.org/repositories/Kernel:/vanilla/standard/
> 
> The 'vanilla' kernel exhibited the same problems.
> The version I tested:  2.6.37-rc4-219-g771f8bc-vanilla.
>
> Incidentally, quick tests of jfs, xfs, and ext3 do _not_ show the same
> problems, although I will note that I usually saw failure at least 1
> in 3, but sometimes had to re-run the sql test 4 or 5 times before I
> saw failure.
> 
> I will continue to do some testing, but I will hold off on testing the
> commits above until I receive further testing suggestions.

OK, so to be clear: your testing is on dm-crypt + ext4?

And you're testing upstream based kernels (meaning the dm-crypt
scalability patch that has been in question is _not_ in the mix)?

That is a very different report than the other 2 reports of corruption
(those corruption instances were only seen once the dm-crypt scalability
patch was introduced).

Mike
