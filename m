From: qixuan wu <wuqixuan@gmail.com>
Subject: Re: Help to know the stable ver of ext4 for commercial app.
Date: Mon, 4 Feb 2013 01:39:58 +0800
Message-ID: <CAEjEV8DaMO8ayPq+uOuuyDD+tXq=bmMoNs5SRMpNUFkWWyweeA@mail.gmail.com>
References: <BB7C62C2B0732E4DA93834A501E8464544E6181A@SZXEML519-MBS.china.huawei.com>
	<20130202032307.GA16364@thunk.org>
	<BB7C62C2B0732E4DA93834A501E8464544E62844@SZXEML519-MBS.china.huawei.com>
	<20130202224305.GA1359@thunk.org>
	<BB7C62C2B0732E4DA93834A501E8464544E628A6@SZXEML519-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: adilger@dilger.ca, Tao Ma <tm@tao.ma>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Li Zefan <lizefan@huawei.com>, linux-ext4@vger.kernel.org,
	wuqixuan <wuqixuan@huawei.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f176.google.com ([209.85.210.176]:55791 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3BCRj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Feb 2013 12:39:58 -0500
Received: by mail-ia0-f176.google.com with SMTP id i18so7221062iac.35
        for <linux-ext4@vger.kernel.org>; Sun, 03 Feb 2013 09:39:58 -0800 (PST)
In-Reply-To: <BB7C62C2B0732E4DA93834A501E8464544E628A6@SZXEML519-MBS.china.huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 3, 2013 at 8:43 PM, Wuqixuan <wuqixuan@huawei.com> wrote:
>
>
> ________________________________________
> =B7=A2=BC=FE=C8=CB: Theodore Ts'o [tytso@mit.edu]
> =B7=A2=CB=CD=CA=B1=BC=E4: 2013=C4=EA2=D4=C23=C8=D5 6:43
> =B5=BD: Wuqixuan
> Cc: adilger@sun.com; tm@tao.ma; xiaoqiangnk@gmail.com; Lizefan; linux=
-ext4@vger.kernel.org
> =D6=F7=CC=E2: Re: Help to know the stable ver of ext4 for commercial =
app.
>
> On Sat, Feb 02, 2013 at 07:20:32AM +0000, Wuqixuan wrote:
>>
>>    From these two paragraphs, my understanding is, during the 18 mon=
ths
>> about the huge number of patches, all the patches which impact 2.6.3=
4.x
>> had been backported into old stable version like 2.6.34.x. If not me=
rge,
>> just because those patches is not applicable to or impat that versio=
n. I am
>> not sure whether I am wrong.
>
> That's not true.  All of the patches which were trivial to apply will
> generally be backported into an old stable version --- but that's
> ultimately up to the person who stood up and took responsibility for
> the doing the stable kernel release for that particular tree.  Greg
> K-H did it for a certain set of kernel releases as "long term stable"
> releases: 2.6.16, 2.6.27, 2.6.32, 3.4.  He originally did that becaus=
e
> he needed to maintain stable trees for SuSE, and he decided to make
> them available as a public service.

> Since then, some other people have decided to do the same for other
> kernel releases.  Paul Gortmaker from Windriver chose to do this for
> 2.6.34, probably because he needed it for his employer, and Ben
> Hutchings chose to do this for 3.2, because that's the version used b=
y
> Debian's upcoming stable kernel version.

OK, I got. So generally feature maintainer submit patch to old stable
branch maintainer, and they decide to patch ? Am I correct ?
Because in old stable branch, the whole kernel is very huge. One
person cannot find all the patch in the high version and decide to
patch.

>>    Another doubt is that currently if a new patch is merged in
>> upstream, who is to be obligated to do backport. The maintainter of
>> ext4 (you) or the stable branch maintiner (like maintiner of
>> 2.6.34.x, i think he is from windriver) ? I saw even in 2013-01-16,
>> still one checkin (commit: 25772970966c268c16ec5c0f9d02449f401663c1)
>> in 2.6.34.14. Does it mean that if one patch is merged in upstream,
>> somebody generally will be obligated to do backport to old stable
>> branches within some period.
>
> No one is obligated to do backport any patch; this is all a volunteer
> effort.  In some cases, a maintainer may do more work because his
> employer very much needs to support a particular file system, but the=
n
> he's doing it because it's in the interest of his employer, and he or
> she is obligated to do so as long as it continues to be in the
> interest of their employer, and as long as the employer is willing to
> let those results get published in a form which is useful to the
> general public.
>
> Note not all employers have choosen to make their results public.  In
> the case of Red Hat, for example, because Oracle was taking their
> kernels and using it as a direct competition, and apparently Red Hat
> management thought Oracle wasn't contributing sufficiently to the
> common effort compared to the economic value they were extracting fro=
m
> the community, Red Hat management has made the decision to not releas=
e
> the broken out patches for RHEL kernels.  They do release a
> multi-megabyte combined patch, as required by GPL, but that's much
> less useful for a competitor to try to use against them.

Actually, i misused the word "obligated",  I just wanted to ask
whether somebody "generally" or "was used to do". I also know the all
people in the community are not the relationship of employment.
Because of less understanding of the machanism of upstream. So please
forgive me.
Now I guess there are some ext4 patches in RHEL latest kernels and not
in the 2.6.32.x branch of vanilla kernel. Also Andreas said in another
mail. I think maybe I need compare the ext4 in RHEL 6 and in the
vanilla kernel. That difference maybe make something clear.

> Part of that is because it takes a huge amount effort to backport
> modern patches to really ancient kernels such as 2.6.32 or 2.6.34.
> And it's definitely not a fun thing to do, and after you do it, you
> have to do a lot of testing to make sure you haven't broken anything.
> I had to do this for Google's internal kernel, and it sure wasn't fun=
,
> I can tell you that.  It represents real value, and if you think a
> competitor might use it without contributing back to the commons, I
> can see why a company might choose not to contribute it back upstream=
=2E

I can imagine. I totally believe that's not funny work. :). Even the
people as strong as you think like that, to say nothing of those like
us.

>>    So for a conclusion, can I think, no valuable patch( or not many
>> patch) is missing to be backport from upstream high version
>> currently ?
>
> On the contrary, it's very likely that there are missing patches that
> were never backported to 2.6.34.  As I said above, backporting patche=
s
> that don't just apply because they are complex is a very tough,
> miserable, error-prone job, and requires that you very much understan=
d
> the code base in question, and that you do a huge amount of testing
> afterwards.  For example, there were some key bug fixes that required
> quota changes that weren't backported into 2.6.32 or 2.6.34 that are
> almost certainly missing from the public stable kernels, because they
> require the quota patches as a prerequisite.  Otherwise, you would
> have to partially rewrite some of the commits.

Ok, seems ext4 of 2.6.34.x in vanilla kernel are missing some
funcationality. Hope not miss too much.

> Other changes may require changes in the VFS or direct I/O or mm
> layers, and dragging in those changes would involve dragging in still
> more changes, until it would be easier and safer just to use a newer
> kernel.  That's fundamentally the problem with staying back on an
> ancient kernel version such as 2.6.34.  People do it because of
> "safety", but when you try backporting lots and lots of fixes, the
> fact that you have to pull in backports means that you start
> decreasing the safety, and you may end up making it worse because no
> one is testing these bastardized backports.  The other reason why
> people stay back on ancient kernel versions is to save work, but then
> doing all of these backports is incredibly painful, and takes a lot o=
f
> work, and again, past a certain point, you're better off just jumping
> to a newer kernel.

Previously I did not realize that the patch backport also related with
VFS/IO/mm layer. I also previously simply thought we can almost
directly copying the 3.x ext4 to reply the folderin 2.6.34.x and
compile without less compiling error. Just because of those incorrect
thought, I simply thought most of patches can be backport easlily.
Hi Ted, how much the proportion or how much of such case is there from
your experience?
But this problem also indicate that the interface of common layer of
kernel also continue to change more. I think that's not good thing.

> That being said, some of the changes might not matter for your
> particular application.  If you aren't using async I/O, or direct I/O=
,
> then patches to fix bugs in AIO or DIO won't matter to you.  Or if ar=
e
> using fallocate because you can predict in advance how much disk spac=
e
> will be needed, then some of the bugs in the delayed allocation write
> paths might not matter for your particular application.

I got your pointer. But currently it's hard to say which feature is
sure that will not be used. But for those advanced feature like quota
we can evaluate maybe.

> I hope this helps,

Thank you very much Ted, for your long long information and experience
and your time. So now my understanding is that (Please correct me if I
am wrong.):
1)  When a bugfix is found and patched, mostly apply in the upstream
latest branch.
2)  At the same time, some commercial company are maintaining the
stable long term branch. And continue to backport bugfix in internel
kernel tree, just few are published in the vanilla kernel. Either for
technical reason, or for commercial reason.
3)  So if I directly select 2.6.34.x vanilla kernel, absolutely I can
meet many bugs. And some latest feature also is not there.
4)  But the commercial distribution like RHEL or Windriver should have
many internel backport and more stable.

In another mail, Andreas suggest to directly use RHEL 6, how do you
think about Windriver4 SP3(whose internel kernel is 2.6.34.x), do you
have some information about the stability of it ? Now our product are
selecting WR4.3, previously we are totally no idea whether we can
trust it or not for commercial use directly. Now from your message,
seems commercial distribution is much better than dircectly from
vanilla kernel. So still hope is there :). Want to ask Windriver FAE
directly and compare the code also. If you have info about WR4.3 ext4
about stability, please kindly share to me.  BTW, my "stability"
concept means just one or two defect can be meet and fix in the lab
for normal functionality. Better hard to touch defect in end-customer
in 2-3 year .

I know you also are difficult directly judge without app scenario. OK,
if let you select in WR4.3, what's your intuition or suggestion, ext3
or ext4? :)

Another question, if I directly take from vanilla kernel for
commercial use, at least from which version do you suggestion?

>                                         - Ted
>
> P.S.  The same is true of security patches.  Whether or not all stabl=
e
> patches get backported to a stable kernel release such as 2.6.32 or
> 2.6.34 is primarily a question of whether someone is willing to do th=
e
> work, and willing to submit it to the stable maintainer.  Which is
> another reason why you might want to consider going to a newer
> long-term stable kernel, such as 3.2 or 3.4, or paying some company
> such as Wind River or Montavista to provide support for not just a
> particular kernel, but specific kernel features, and make it _their_
> problem to be obliged to make sure all of the needed commits are
> backported.

> Montavista is currently on my sh*t list, BTW, because one of their
> engineers somehow thought I was responsible for providing free
> consultation work on a patch which was over 2-3 years old, and
> wouldn't even tell me what was wrong, but just "it doesn't seem to
> work that well".  Given that Montavista is getting paid by their
> customers for the engineering work, asking a volunteer to provide fre=
e
> engineering work was in very bad taste, and it was even worst taste
> not to even give me a well formed bug report, but instead he assumed =
I
> would do code archeology --- for free.  When a distribuion which
> doesn't provide any contributions to the upstream mainline kernel,
> this is a really good way to piss off a subsystem maintainer....

I totaly agree with you. All the people in the community are just
volunteer. All the maintainer are using the private time to help other
people. Their works should be respected. And ask for any help
absolutely need provide enough information.

When endding the long mail, again say thanks to you, Ted.

Best Regard.
Wood.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
