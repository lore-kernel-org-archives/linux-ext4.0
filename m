From: Matt <jackdachef@gmail.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Sun, 5 Dec 2010 00:52:36 +0100
Message-ID: <AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com>
References: <4CE05A9E.9090204@redhat.com>
	<AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com>
	<AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
	<20101201165229.GC13415@redhat.com>
	<AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
	<4CF692D1.1010906@redhat.com>
	<AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
	<4CF6B3E8.2000406@redhat.com>
	<20101201212310.GA15648@redhat.com>
	<AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
	<20101204193828.GB13871@redhat.com>
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
In-Reply-To: <20101204193828.GB13871@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Dec 4, 2010 at 8:38 PM, Mike Snitzer <snitzer@redhat.com> wrote=
:
> On Sat, Dec 04 2010 at =A02:18pm -0500,
> Matt <jackdachef@gmail.com> wrote:
>
>> On Wed, Dec 1, 2010 at 10:23 PM, Mike Snitzer <snitzer@redhat.com> w=
rote:
>> > Matt and Jon,
>> >
>> > If you'd be up to it: could you try testing your dm-crypt+ext4
>> > corruption reproducers against the following two 2.6.37-rc commits=
:
>> >
>> > 1) 1de3e3df917459422cb2aecac440febc8879d410
>> > then
>> > 2) bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc
>> >
>> > Then, depending on results of no corruption for those commits, bon=
us
>> > points for testing the same commits but with Andi and Milan's late=
st
>> > dm-crypt cpu scalability patch applied too:
>> > https://patchwork.kernel.org/patch/365542/
>> >
>> > Thanks!
>> > Mike
>> >
>>
>> Hi Mike,
>>
>> it seems like there isn't even much testing to do:
>>
>> I tested all 3 commits / checkouts by re-compiling gcc which was/is
>> the 2nd easy way to trigger this "corruption", compiling google's
>> chromium (v9) and looking at the output/existance of gcc, g++ and
>> eselect opengl list
>
> Can you be a bit more precise about what you're doing to reproduce?
> What sequence? =A0What (if any) builds are going in parallel? =A0Etc.
>
>> so far everything went fine
>>
>> After that I used the new patch (v6 or pre-v6), before that I had to
>>
>> replace WQ_MEM_RECLAIM with WQ_RESCUER
>>
>> and, re-compiled the kernels
>>
>> shortly after I had booted up the system with the first kernel
>> (http://git.eu.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.g=
it;a=3Dcommit;h=3D5a87b7a5da250c9be6d757758425dfeaf8ed3179)
>> the output of 'eselect opengl list' did show no opengl backend
>> selected
>>
>> so it seems to manifest itself even earlier (ext4: call
>> mpage_da_submit_io() from mpage_da_map_blocks()) even if only subtly
>> and over time -
>> I'm still currently running that kernel and posting from it & having=
 tests run
>
> OK.
>
>> I'm not sure if it's even a problem with ext4 - I haven't had the ti=
me
>> to test with XFS yet - maybe it's also happening with that so it mor=
e
>> likely would be dm-core, like Milan suspected
>> (http://marc.info/?l=3Dlinux-kernel&m=3D129123636223477&w=3D2) :(
>
> It'd be interesting to try to reproduce with that same kernel but usi=
ng
> XFS. =A0I'll check with Milan on what he thinks would be the best nex=
t
> steps. =A0Ideally we'll be able to reproduce your results to aid in
> pinpointing the issue. =A0I think Milan will be trying to do so short=
ly
> (if he hasn't started already -- using gentoo emerge, etc).
>
>> even though most of the time it's compiling I don't need to do much =
-
>> I need the box for work so if my time allows next tests would be nex=
t
>> weekend and I'm back to my other partition
>>
>> I really do hope that this bugger can be nailed down ASAP - I like t=
he
>> improvements made in 2.6.37 but without the dm-crypt multi-cpu patch
>> it's only half the "fun" ;)
>
> Sure, we'll need to get to the bottom of this before we can have
> confidence sending the dm-crypt cpu scalability patch upstream.
>
> Thanks for your testing,
> Mike
>

I should have made it clear that the results I get are observed when
using the kernels/checkouts *with* the dm-crypt multi-cpu patch,
without the patch I didn't see that kind of problems (hardlocks, files
missing, etc.)
