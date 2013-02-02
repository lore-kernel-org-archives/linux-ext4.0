From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Help to know the stable ver of ext4 for commercial app.
Date: Sat, 2 Feb 2013 17:43:05 -0500
Message-ID: <20130202224305.GA1359@thunk.org>
References: <BB7C62C2B0732E4DA93834A501E8464544E6181A@SZXEML519-MBS.china.huawei.com>
 <20130202032307.GA16364@thunk.org>
 <BB7C62C2B0732E4DA93834A501E8464544E62844@SZXEML519-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "adilger@sun.com" <adilger@sun.com>, "tm@tao.ma" <tm@tao.ma>,
	"xiaoqiangnk@gmail.com" <xiaoqiangnk@gmail.com>,
	Lizefan <lizefan@huawei.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Wuqixuan <wuqixuan@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46649 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab3BBWnO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Feb 2013 17:43:14 -0500
Content-Disposition: inline
In-Reply-To: <BB7C62C2B0732E4DA93834A501E8464544E62844@SZXEML519-MBS.china.huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 02, 2013 at 07:20:32AM +0000, Wuqixuan wrote:
> 
>    From these two paragraphs, my understanding is, during the 18 months 
> about the huge number of patches, all the patches which impact 2.6.34.x 
> had been backported into old stable version like 2.6.34.x. If not merge, 
> just because those patches is not applicable to or impat that version. I am 
> not sure whether I am wrong. 

That's not true.  All of the patches which were trivial to apply will
generally be backported into an old stable version --- but that's
ultimately up to the person who stood up and took responsibility for
the doing the stable kernel release for that particular tree.  Greg
K-H did it for a certain set of kernel releases as "long term stable"
releases: 2.6.16, 2.6.27, 2.6.32, 3.4.  He originally did that because
he needed to maintain stable trees for SuSE, and he decided to make
them available as a public service.

Since then, some other people have decided to do the same for other
kernel releases.  Paul Gortmaker from Windriver chose to do this for
2.6.34, probably because he needed it for his employer, and Ben
Hutchings chose to do this for 3.2, because that's the version used by
Debian's upcoming stable kernel version.

>    Another doubt is that currently if a new patch is merged in
> upstream, who is to be obligated to do backport. The maintainter of
> ext4 (you) or the stable branch maintiner (like maintiner of
> 2.6.34.x, i think he is from windriver) ? I saw even in 2013-01-16,
> still one checkin (commit: 25772970966c268c16ec5c0f9d02449f401663c1)
> in 2.6.34.14. Does it mean that if one patch is merged in upstream,
> somebody generally will be obligated to do backport to old stable
> branches within some period.

No one is obligated to do backport any patch; this is all a volunteer
effort.  In some cases, a maintainer may do more work because his
employer very much needs to support a particular file system, but then
he's doing it because it's in the interest of his employer, and he or
she is obligated to do so as long as it continues to be in the
interest of their employer, and as long as the employer is willing to
let those results get published in a form which is useful to the
general public.

Note not all employers have choosen to make their results public.  In
the case of Red Hat, for example, because Oracle was taking their
kernels and using it as a direct competition, and apparently Red Hat
management thought Oracle wasn't contributing sufficiently to the
common effort compared to the economic value they were extracting from
the community, Red Hat management has made the decision to not release
the broken out patches for RHEL kernels.  They do release a
multi-megabyte combined patch, as required by GPL, but that's much
less useful for a competitor to try to use against them.

Part of that is because it takes a huge amount effort to backport
modern patches to really ancient kernels such as 2.6.32 or 2.6.34.
And it's definitely not a fun thing to do, and after you do it, you
have to do a lot of testing to make sure you haven't broken anything.
I had to do this for Google's internal kernel, and it sure wasn't fun,
I can tell you that.  It represents real value, and if you think a
competitor might use it without contributing back to the commons, I
can see why a company might choose not to contribute it back upstream.

>    So for a conclusion, can I think, no valuable patch( or not many
> patch) is missing to be backport from upstream high version
> currently ?

On the contrary, it's very likely that there are missing patches that
were never backported to 2.6.34.  As I said above, backporting patches
that don't just apply because they are complex is a very tough,
miserable, error-prone job, and requires that you very much understand
the code base in question, and that you do a huge amount of testing
afterwards.  For example, there were some key bug fixes that required
quota changes that weren't backported into 2.6.32 or 2.6.34 that are
almost certainly missing from the public stable kernels, because they
require the quota patches as a prerequisite.  Otherwise, you would
have to partially rewrite some of the commits.

Other changes may require changes in the VFS or direct I/O or mm
layers, and dragging in those changes would involve dragging in still
more changes, until it would be easier and safer just to use a newer
kernel.  That's fundamentally the problem with staying back on an
ancient kernel version such as 2.6.34.  People do it because of
"safety", but when you try backporting lots and lots of fixes, the
fact that you have to pull in backports means that you start
decreasing the safety, and you may end up making it worse because no
one is testing these bastardized backports.  The other reason why
people stay back on ancient kernel versions is to save work, but then
doing all of these backports is incredibly painful, and takes a lot of
work, and again, past a certain point, you're better off just jumping
to a newer kernel.

That being said, some of the changes might not matter for your
particular application.  If you aren't using async I/O, or direct I/O,
then patches to fix bugs in AIO or DIO won't matter to you.  Or if are
using fallocate because you can predict in advance how much disk space
will be needed, then some of the bugs in the delayed allocation write
paths might not matter for your particular application.

I hope this helps,

					- Ted

P.S.  The same is true of security patches.  Whether or not all stable
patches get backported to a stable kernel release such as 2.6.32 or
2.6.34 is primarily a question of whether someone is willing to do the
work, and willing to submit it to the stable maintainer.  Which is
another reason why you might want to consider going to a newer
long-term stable kernel, such as 3.2 or 3.4, or paying some company
such as Wind River or Montavista to provide support for not just a
particular kernel, but specific kernel features, and make it _their_
problem to be obliged to make sure all of the needed commits are
backported.

Montavista is currently on my sh*t list, BTW, because one of their
engineers somehow thought I was responsible for providing free
consultation work on a patch which was over 2-3 years old, and
wouldn't even tell me what was wrong, but just "it doesn't seem to
work that well".  Given that Montavista is getting paid by their
customers for the engineering work, asking a volunteer to provide free
engineering work was in very bad taste, and it was even worst taste
not to even give me a well formed bug report, but instead he assumed I
would do code archeology --- for free.  When a distribuion which
doesn't provide any contributions to the upstream mainline kernel,
this is a really good way to piss off a subsystem maintainer....
