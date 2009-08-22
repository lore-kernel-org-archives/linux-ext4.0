From: Lawrence Greenfield <leg@google.com>
Subject: Re: RFC: Clarifying Direct I/O Semantics
Date: Sat, 22 Aug 2009 09:25:20 -0400
Message-ID: <5956ddbe0908220625h6a6eeba2w679602d3a1f6336c@mail.gmail.com>
References: <E1Mec4O-0005ka-NN@closure.thunk.org> <4A8F1FA5.5080501@hp.com>
	 <20090822000745.GP9529@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:37592 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbZHVNZX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Aug 2009 09:25:23 -0400
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id n7MDPNHg002234
	for <linux-ext4@vger.kernel.org>; Sat, 22 Aug 2009 14:25:23 +0100
Received: from qw-out-1920.google.com (qwk4.prod.google.com [10.241.195.132])
	by wpaz29.hot.corp.google.com with ESMTP id n7MDPKja015169
	for <linux-ext4@vger.kernel.org>; Sat, 22 Aug 2009 06:25:20 -0700
Received: by qw-out-1920.google.com with SMTP id 4so890406qwk.10
        for <linux-ext4@vger.kernel.org>; Sat, 22 Aug 2009 06:25:20 -0700 (PDT)
In-Reply-To: <20090822000745.GP9529@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 21, 2009 at 8:07 PM, Theodore Tso<tytso@mit.edu> wrote:
> On Fri, Aug 21, 2009 at 06:28:53PM -0400, jim owens wrote:
>>> The Linux man page does not state what happens if the alignment
>>> restrictions are not met; does the kernel start running rogue or
>>> nethack; does it send a signal such as SIGSEGV or SIGABORT, and kil=
l the
>>> running process; or does it fall back to buffered I/O? Today, the a=
nswer
>>> is the latter; but it's not specified anywhere.
>>
>> retval =3D -EINVAL; is what __blockdev_direct_IO does in that case
>> and what I was making btrfs directIO do. =C2=A0but fall back is OK t=
oo
>> if we really want. what existing code fixes up the EINVAL?
>
> You're right; I thought it did the fallback in all cases, but it only
> does it when writing into holes. =C2=A0Oops. =C2=A0I should have test=
ed this
> before saying it.
>
> I'll fix up the wiki page.

I think failing when O_DIRECT can't be honored is the right thing.
Applications can't verify O_DIRECT behavior, so it's important to tell
an application that the kernel can't do what they're asking for.

>
>>> This is relatively well understood by most implementors and users o=
f
>>> O_DIRECT as part of the "oral lore", so simply updating the Linux m=
an
>>> page should not be controversial.
>>>
>>
>> The following section includes "sparse" AKA "allocating" writes but
>> just says "extending". =C2=A0Either sparse-filling write needs cover=
ed
>> separately or we should say "allocating" instead of "extending.
>
> Yup, good point.
>
>> Possibly it should just be stated that directIO write data integrity
>> is based on the setting of posix O_SYNC and O_DSYNC. =C2=A0Then it i=
s their
>> choice to run slow-and-safe or fast. =C2=A0O_SYNC requires metadata =
on disk.
>
> The question in my mind is whether we should guarantee that the data
> block is written synchronously for allocating writes when the file
> metadata is not written synchronously; what's the point? =C2=A0After =
all,
> the application can't distinguish between the data block not making i=
t
> out to disk, versus the metadata that will allow the data block to be
> accessed after a crash, why should one by synchronous but not the
> other?

O_DIRECT is about avoiding polluting the buffer cache, not only about
data integrity. If an application wants allocating writes to have a
data integrity guarantee, they can open the file O_DIRECT|O_DSYNC, at
the cost that writes they think might be one disk seek end up being 2
(or more). But please don't fall back to putting the data into the
buffer cache!

I think it would be useful to be explicit to applications what they
need to do for O_DIRECT writes to be guaranteed to be visible after a
crash. As a naive application writer, I would have thought using
posix_fallocate would have been "good enough". If I understand
correctly, an application that wants to know that O_DIRECT writes will
both avoid the buffer cache and be visible after a crash must
guarantee that it's previously written to those blocks either O_DSYNC
or has used fdatasync() on the file after such writes. All subsequent
writes can be done with only O_DIRECT.

That means that a database must explicitly initialize its files by
writing 0s: it can't rely on posix_fallocate. (Amusingly, it would
have worked before fallocate() was introduced into the kernel!)

Larry

>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
