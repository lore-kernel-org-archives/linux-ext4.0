From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH] ext4: fix racy use-after-free in ext4_end_io_dio()
Date: Thu, 24 Nov 2011 15:52:50 -0800
Message-ID: <CAH+dOx+pfCXJ-zCb-CzfHevD_J8K5DHNEuvK0_KvQtk=xVLfdA@mail.gmail.com>
References: <20111124194626.GA5260@google.com>
	<20111124231848.GC5167@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>, Tejun Heo <tj@kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kent Overstreet <koverstreet@google.com>, rickyb@google.com,
	aberkan@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45069 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab1KXXwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Nov 2011 18:52:51 -0500
Received: by iage36 with SMTP id e36so3665844iag.19
        for <linux-ext4@vger.kernel.org>; Thu, 24 Nov 2011 15:52:51 -0800 (PST)
In-Reply-To: <20111124231848.GC5167@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Heh. It took me about 2 seconds to trigger it in vm :)

One reason it triggered so fast is that my VM test setup runs
everything out of ram (the disks on the host are files in a tmpfs),
but the main reason we were hitting it is that bcache usually runs the
bio->bi_endio function out of a workqueue, not irq context.

It also seems to only trigger when a dio write is extending a file;
the same test setup run against an existing file doesn't ever cause
(visible) slab corruption.

Do you think this would also explain the corruption D is seeing in vd?
I haven't yet figured out a mechanism but the bug seems to fit.

On Thu, Nov 24, 2011 at 3:18 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Nov 24, 2011 at 11:46:26AM -0800, Tejun Heo wrote:
>> ext4_end_io_dio() queues io_end->work and then clears iocb->private;
>> however, io_end->work completes the iocb by calling aio_complete(),
>> which may happen before io_end->work clearing thus leading to
>> use-after-free.
>>
>> Detected and tested with slab poisoning.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Reported-by: Kent Overstreet <koverstreet@google.com>
>> Tested-by: Kent Overstreet <koverstreet@google.com>
>> Cc: stable@kernel.org
>
> Thanks!! =A0I've been trying to track down this bug for a while. =A0T=
he
> repro case I had ran the 12 fio's against 12 different file systems
> with the following configuration:
>
> [global]
> direct=3D1
> ioengine=3Dlibaio
> iodepth=3D1
> bs=3D4k
> ba=3D4k
> size=3D128m
>
> [create]
> filename=3D${TESTDIR}
> rw=3Dwrite
>
> ... and would leave a few inodes with elevated i_ioend_counts, which
> means any attempt to delete those inodes or to unmount the file syste=
m
> owning those inodes would hang forever.
>
> With your patch this problem goes away.
>
>>I *think* this is the correct fix but am not too familiar with code
>>path, so please proceed with caution.
>
> Looks good to me. =A0Thanks, applied.
>
>>Thank you.
>
> No, thank *you*! =A0:-)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
>
> P.S. =A0It would be nice to get this into xfstests, but it requires a=
t
> least 10-12 (12 to repro it reliably) HDD's, and a fairly high core
> count machine in order to reproduce it. =A0I played around with tryin=
g
> to create a reproducer that worked on a smaller number of disks and/o=
r
> fio's/CPU's, but I was never able to manage it.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
