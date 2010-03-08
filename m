From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: RFC: EXT4 Defrag Specification (Draft)
Date: Mon, 8 Mar 2010 09:30:57 -0500
Message-ID: <87f94c371003080630g15b68431m2a2829a4ccb0df0b@mail.gmail.com>
References: <4B94F771.4010507@josephdwagner.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Joseph D. Wagner" <theman@josephdwagner.info>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f196.google.com ([209.85.223.196]:55699 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab0CHOa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Mar 2010 09:30:58 -0500
Received: by iwn34 with SMTP id 34so727783iwn.15
        for <linux-ext4@vger.kernel.org>; Mon, 08 Mar 2010 06:30:57 -0800 (PST)
In-Reply-To: <4B94F771.4010507@josephdwagner.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 8, 2010 at 8:11 AM, Joseph D. Wagner
<theman@josephdwagner.info> wrote:
> Hello.
>
> I am very interested in EXT4's defrag capabilities. =A0I haven't been=
 able to
> find much documentation on them or even a formal specification for th=
em. =A0I
> was hoping to help nudge the process along by drafting the specificat=
ion
> that I have been unable to find.
>
> Please keep in mind that I am a newbie when it comes to kernel progra=
mming.
> =A0I may be way off on my assumptions or seriously misinformed, or pe=
rhaps you
> already have a plan and I was simply unable to find it. =A0Please do =
not hold
> it against me. =A0Also, I was hoping to be further along before posti=
ng.
> =A0However, people were starting to ask questions, so I figured it wa=
s better
> to post an incomplete draft and finish it out later.
>
> Please let me know what you think of the draft thus far. =A0Thank you=
 for your
> time.
>
> http://www.josephdwagner.info/ext4_defrag_specs.html
>

Your spec pretty much misses the mark.

Have you read the "spec" email: http://markmail.org/message/qp7zjhhdzxu=
m7rfn

Have you looked at the EXT4_IOC_MOVE_EXT ioctl and e4defrag code?
Have you read the last 9 months ext4 mailing list discussion related
to it?

http://markmail.org/search/?q=3De4defrag#query:e4defrag%20date%3A200906=
-201003%20+page:1+state:facets

(Much of that is not critical to read, but there should be some good
stuff in there as well.)

some comments:

>>
The current method of defragmenting is to copy the entire file to free
space, and check to see if the new file just-so-happened to use fewer
extents than the original; if so, switch to the new file; otherwise,
drop the new file.
<<

Not correct - Step one is currently to fallocate a new set of donor
data blocks associated with a new temporary donor inode.  fallocate is
fast and does not involve copying any actual data around.  It is the
donor files fragmentation that is compared to the original before
proceeding to actually copy the data in the original data blocks to
the donor blocks.  (That is what ext4_ioc_move_ext does.)

>>
One shortcoming with the current model is that is places the burden on
the kernel to perform the entire process, which becomes more
burdensome as file size increases. This also places a burden on
programmers, because any errors have the potential to crash the entire
system. From this, one can derive that:

    * The defrag process should be compartmentalized into a few,
primitive kernel functions.

A privileged user space process would call these functions as it sees
fit to defragment files. This would allow tight quality control of the
underlying kernel functions. At the same time, this would allow
programmers the freedom to try more experimental optimization
algorithms in the user space program without risking the entire
system.
<<

I very much disagree with the above.  The only implemented kernel
function at present is ext4_ioc_move_ext().  That will always be one
of the primitives.

You argue later that it should be called on smaller chunks of data
blocks / extents than the full file and I agree, but there is nothing
wrong with the current conceptual design of ext4_ioc_move_ext().

Where there is currently a shortcoming is in the allocation of donor
blocks / extents.  This is currently done with a simple fallocate
call.  Ted T'so proposed a couple additional ioctl's to manage how
blocks are allocated in general.  If implemented they could be called
prior to e4defrag calling fallocate to control how the blocks/extents
are allocated.

Again see http://markmail.org/message/qp7zjhhdzxum7rfn

>>
Defragging the entire file is suboptimal, especially in a case where
there is insufficient space to defrag the entire file (e.g. a database
server). Even if there was enough space, there is no guarantee that
the new file will be any less fragmented. Checking after-the-fact is
extremely suboptimal, especially considering the massive amount of
data that may need to be copied. From this, one can derive that:

    * The defrag process must be able to work with parts of files.
    * The defrag process must be able to guarantee that output will be
less fragmented than input.

Both of these goals can be accomplished if defragmenting took place at
the extent level, instead of the file level, by merging extents.
<<

Wording issue about some of the above, but in general agree except for
the inefficiency part.  Note that 100% of the above is controlled by
user space, so the fix is in e4defrag, not the kernel.

>>
=46ast abort
<<

I think we have that now so you should drop this section.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
