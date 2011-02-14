From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Mon, 14 Feb 2011 23:22:11 +0200
Message-ID: <AANLkTimJwBTvyYtjQfiOGXYFunC035NCfOpTCnkDQzzu@mail.gmail.com>
References: <20110203144011.GA28409@quack.suse.cz>
	<4D4AC4E2.701@redhat.com>
	<AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
	<20110204131739.GC4104@quack.suse.cz>
	<AANLkTin=6wY6y0LZCDtMGiy8vmdok=UUj-7rmsTPAVuh@mail.gmail.com>
	<20110214172504.GC3018@quack.suse.cz>
	<AANLkTimdApPPK6FkH+CPrXdNpND6_twE2voRiNhgQOOE@mail.gmail.com>
	<20110214195845.GD4255@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Michael Rubin <mrubin@google.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48230 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab1BNVWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Feb 2011 16:22:12 -0500
Received: by qyj19 with SMTP id 19so1815414qyj.19
        for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 13:22:12 -0800 (PST)
In-Reply-To: <20110214195845.GD4255@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 14, 2011 at 9:58 PM, Ted Ts'o <tytso@mit.edu> wrote:
> -lsf-pc, -linux-fsdevel
>
> On Mon, Feb 14, 2011 at 09:00:58PM +0200, Amir Goldstein wrote:
>> Yes, of course. Upgraders won't be the ones using snapshots.
>> My intension was to state that those people installing new systems t=
o test
>> snapshots would be functioning as testers for "ext3 mode", because:
>> 1. when no snapshots exists it boils down to testing "ext3 mode".
>> 2. it is unlikely that snapshots will mask "ext3 mode" bugs.
>>
>> So my claim is that "ext3 mode" would benefit from a transition
>> period in which snapshots and (extens,delalloc) are mutually
>> exclusive in ext4.
>
> Here are the requirements that I think are critical before we do this=
:
>
> 1) We need to solve the testing matrix problem. =A0Right now "ext3 mo=
de"
> in ext4 doesn't get enough testing as it is. =A0Part of the solution =
is
> (a) deciding on the modes that need testing, and (b) writing some
> shell scripts so that xfstests can be automatically run in all of the
> right modes. =A0And then it will be having some number of people
> (hopefully not just me) running said tests and reporting failures.
>
> 2) The code has to integrate in a fairly seemless and easy way.
> mballoc.c is an example of code that still needs a lot of cleanup.
> Coly Li has submitted some cleanups, which is great. =A0But I suspect=
 a
> lot more is needed.
>
> One thing that comes to mind about your question with the
> e4b->alloc_semp causing problems. =A0If the only reason why we need i=
t
> is to protect against multiple attempts to initialize different block
> groups that share the same buddy bitmap, can we solve the problem by
> ditching e4b->alloc_semp entirely, and simply using lock_page() on th=
e
> buddy bitmap page to protect it?
>

Perhaps. I imagine there is more than one elegant way to deal with that=
,
but using a semaphore is not one of them.
I will take a shot at evaporating e4b->alloc_semp.

> That's an example of the radical code cleanup and simplification that
> parts of the ext4 codebase could really use. =A0That isn't the
> snapshot's code fault, and if we didn't really need to touch parts th=
e
> code in question, it's probably stable enough as it is.
> Unfortunately, if you need to make changes, there's enough code debt
> in some of the files that you need to change that any changes _has_ t=
o
> make things better, and not worse. =A0So for example, checking to see=
 if
> the blocksize=3D=3Dpage_size, and then skipping the down_read(alloc_s=
mp)
> call is an example of layering _more_ complexity and code hackery, an=
d
> not less.
>

=46air enough. I accept the challenge.
I shall cleanup mballoc.c in the process of merging snapshots code.
If you have specific things that bug you in mballoc.c, let me know.


> Note what I did with patches in the ext4_da_writepages() codepath ---
> about 100 lines of code removed in just 7 patches, and I expect
> performance will get better as a result of the cleanup. =A0And then
> compare that to how that code looked in say, 2.6.27. =A0We need to do
> similar amounts of cleanup in other parts of ext4 --- and mballoc.c i=
s
> by no means the worse. =A0But building on top of code which has a fai=
r
> amount of code debt, is not a receipe for long-term success; it's lik=
e
> building a castle on quicksand, or in a swamp (insert obligatory Mont=
y
> Python reference here).
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
