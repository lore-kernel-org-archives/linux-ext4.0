From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Tue, 7 Dec 2010 12:10:49 -0600
Message-ID: <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
References: <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
 <20101201165229.GC13415@redhat.com> <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com> <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
 <20101207142145.GA27861@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>, Matt <jackdachef@gmail.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Milan Broz <mbroz@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <li
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:40264 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0LGSLL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Dec 2010 13:11:11 -0500
In-Reply-To: <20101207142145.GA27861@think>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I finally found some time to test this out. With 2.6.37-rc4 (openSUSE
KOTD kernel) I easily encounter the issue.

Using a virtual machine, I created a stock, minimal openSUSE 11.3 x86_64
install, installed all updates, installed postgresql and the 'KOTD'
(Kernel of the Day)
kernel, and ran the following tests (as postgres user because I'm
lazy).

1. create a database (from bash):

createdb test

2. place the following contents in a file (I used 't.sql'):

begin;
create temporary table foo as select x as a, ARRAY[x] as b FROM
generate_series(1, 10000000 ) AS x;
create index foo_a_idx on foo (a);
create index foo_b_idx on foo USING GIN (b);
rollback;

3. execute that sql:

psql -f t.sql --echo-all test


With 2.6.34.7 I can re-run [3] all day long, as many times as I want,
without issue.

With 2.6.37-rc4-13 (the currently-installed KOTD kernel) if tails
pretty frequently.

Then I tested with the 'vanilla' kernel available here:

http://download.opensuse.org/repositories/Kernel:/vanilla/standard/

The 'vanilla' kernel exhibited the same problems.
The version I tested:  2.6.37-rc4-219-g771f8bc-vanilla.

Incidentally, quick tests of jfs, xfs, and ext3 do _not_ show the same
problems, although I will note that I usually saw failure at least 1
in 3, but sometimes had to re-run the sql test 4 or 5 times before I
saw failure.

I will continue to do some testing, but I will hold off on testing the
commits above until I receive further testing suggestions.

-- 
Jon
