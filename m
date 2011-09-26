From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] Add better example about how to compress e2image raw image
Date: Mon, 26 Sep 2011 23:01:37 +0300
Message-ID: <CAOQ4uxiiJk79nz-ftVPNpCY_VYxLAH8QGR8+p9aAa3fheGs54w@mail.gmail.com>
References: <1316803672-25550-1-git-send-email-cmaiolino@redhat.com>
	<BAB1C1C4-D0BB-4398-89A5-EC8B1E20801B@dilger.ca>
	<20110923205124.GD26962@andromeda.usersys.redhat.com>
	<20110924163153.GB2779@thunk.org>
	<4E80A73F.2070205@redhat.com>
	<20110926192358.GC3282@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	Shardul Mangade <shardul27@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45048 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1IZUBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Sep 2011 16:01:39 -0400
Received: by wwf22 with SMTP id 22so7249690wwf.1
        for <linux-ext4@vger.kernel.org>; Mon, 26 Sep 2011 13:01:38 -0700 (PDT)
In-Reply-To: <20110926192358.GC3282@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 26, 2011 at 10:23 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Sep 26, 2011 at 11:24:31AM -0500, Eric Sandeen wrote:
>> >
>> > =A0 =A0 bunzip2 < hda1.e2i.bz2 | make-sparse hda1.e2i
>> >
>> > ... and this creates a sparse file in hda1.e2i.
>>
>> or | cp --sparse=3Dalways /dev/stdin sparse.img works too.
>>
>> But have you ever tried this with a multi-terabyte image?
>>
>> It takes -forever- to process all those 0s, with cpus pegged.
>
> Yeah, I didn't realize until I read another message on this thread
> that bzip2's CPU problems were causing problems. =A0Is gzip sufficien=
tly
> better, I wonder, or is it still problematic?
>
>> Ted, your concern about space - it doesn't take the full fs size wor=
th
>> of space, right, just the metadata space? =A0So in general it should=
 not
>> be THAT much ...
>
> Yes, it's just the metadata space that I was worried about. =A0So it'=
s
> not *that* much, but it still adds up on large systems. =A0But then
> again, on large systems we precisely have the problem of bzip2 taking
> forever.
>
> If we decide that we're OK with not compressing qcow2, we could use
> qcow2. =A0But note that the qcow2 format is still very compressible -=
--
> it looks like it could do a better job removing zero blocks. =A0(I ha=
d a
> 256meg qcow2 e2image file compress down to 9 megs.) =A0Unfortunately =
we
> can't do stream compression with qcow2.

I wasn't sure if I should bring this up, but what the hack...
Shardul, one of our GSoC students, have implemented e4send/e4receive
for streaming of ext4
snapshot image (with data) to a remote machine. The code can be found
in his github repo:
https://github.com/shardulmangade/e2fsprogs-snapshots

His code mostly reuses e2image code and uses "LVM snapshot store"
format for streaming
block numbers + blocks content to e4receive, which writes to a sparse
file or block device.
LVM snapshot store format was chosen simply because we needed
something quick and the code was already implemented by another GSoC st=
udent
for his own project (revert to ext4 snapshot using LVM merge).

So without trying to promote upstream inclusion of this implementation,
just so you know:
1. the code works, although not configured for exporting metadata at th=
e moment
2. it's simple
3. no intermediate files needed
4. output can be streamed compressed
5. Shardul would be happy to help with further questions

Amir.

>
> Long run I think we should make the qcow2 support better (by dropping
> all-zero blocks, and adding support for qcow2 to
> debugfs/dumpe2fs/e2fsck, and perhaps adding support for native
> compression). =A0Anyone looking for a project? =A0:-)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
