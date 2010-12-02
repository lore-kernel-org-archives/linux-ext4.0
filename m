From: Matt <jackdachef@gmail.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Thu, 2 Dec 2010 22:30:16 +0100
Message-ID: <AANLkTi=mi53SLEGisC5BXbJO0-BXWG_THjH84uum2Com@mail.gmail.com>
References: <20101114205925.GA20451@redhat.com>
	<AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
	<4CE05A9E.9090204@redhat.com>
	<AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com>
	<AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
	<20101201165229.GC13415@redhat.com>
	<AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
	<4CF692D1.1010906@redhat.com>
	<AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
	<4CF6B3E8.2000406@redhat.com>
	<20101201212310.GA15648@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Milan Broz <mbroz@redhat.com>, Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>,
	Chris Mason <chris.mason@oracle.com>, htejun@gmail.com,
	linux-ext4@vger.kernel.org, Jon Nelson <jnelson@jamponi.net>
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101201212310.GA15648@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 1, 2010 at 10:23 PM, Mike Snitzer <snitzer@redhat.com> wrot=
e:
> On Wed, Dec 01 2010 at =A03:45pm -0500,
> Milan Broz <mbroz@redhat.com> wrote:
>
>>
>> On 12/01/2010 08:34 PM, Jon Nelson wrote:
>> > Perhaps this is useful: for myself, I found that when I started us=
ing
>> > 2.6.37rc3 that postgresql starting having a *lot* of problems with
>> > corruption. Specifically, I noted zeroed pages, corruption in head=
ers,
>> > all sorts of stuff on /newly created/ tables, especially during in=
dex
>> > creation. I had a fairly high hit rate of failure. I backed off to
>> > 2.6.34.7 and have *zero* problems (in fact, prior to 2.6.37rc3, I =
had
>> > never had a corruption issue with postgresql). I ran on 2.6.36 for=
 a
>> > few weeks as well, without issue.
>> >
>> > I am using kcrypt with lvm on top of that, and ext4 on top of that=
=2E
>>
>> With unpatched dmcrypt (IOW with Linus' git)? Then it must be ext4 o=
r
>> dm-core problem because there were no patches for dm-crypt...
>
> Matt and Jon,
>
> If you'd be up to it: could you try testing your dm-crypt+ext4
> corruption reproducers against the following two 2.6.37-rc commits:
>
> 1) 1de3e3df917459422cb2aecac440febc8879d410
> then
> 2) bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc
>
> Then, depending on results of no corruption for those commits, bonus
> points for testing the same commits but with Andi and Milan's latest
> dm-crypt cpu scalability patch applied too:
> https://patchwork.kernel.org/patch/365542/
>
> Thanks!
> Mike
>

Yeah sure,

I'll have to set up another testing system (on a separate partition /
volume group) for its own so that will take some time,
first tests will be run probably in the weekend,

thanks for those pointers !

I took a look at git-web - you think
5a87b7a5da250c9be6d757758425dfeaf8ed3179 might be relevant, too ?

the others seem rather minor compared to those you posted

Afaik last time I run vanilla 2.6.37-rc* (which was probably around
rc1) I saw no corruption at all but I'll give it a test-run without
the dm-crypt patch anyway

Thanks & Regards

Matt
