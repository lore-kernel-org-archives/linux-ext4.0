From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: fsck performance.
Date: Mon, 21 Feb 2011 11:00:02 -0700
Message-ID: <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca>
References: <20110220090656.GA11402@bitwizard.nl> <20110220170931.GB3017@thunk.org> <20110220193406.GC3017@thunk.org> <20110220215531.GA21917@bitwizard.nl> <20110220222013.GA2849@thunk.org> <20110220231514.GC21917@bitwizard.nl> <20110220234131.GC4001@thunk.org> <AANLkTikJs8mBHGvHkJAp-aC719aG6QSJaUH-uvwpx0JK@mail.gmail.com> <AANLkTinWOSBqkXhgOa4qdfK+iiLcJSP9LeZaYmUHH9KF@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Amir Goldstein <amir73il@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	linux-ext4@vger.kernel.org
To: =?utf-8?Q?Pawe=C5=82_Brodacki?= <pawel.brodacki@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:2321 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1BVEA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Feb 2011 23:00:56 -0500
In-Reply-To: <AANLkTinWOSBqkXhgOa4qdfK+iiLcJSP9LeZaYmUHH9KF@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-21, at 9:04 AM, Pawe=C5=82 Brodacki wrote:
> 2011/2/21 Amir Goldstein <amir73il@gmail.com>:
>> One thing I am not sure I understand is (excuse my ignorance) why is=
 the
>> swap space solution good only for 64bit processors?
>=20
> It's an address space limit on 32 bit processors. Even with PAE the
> user space process still won't have access to more than 2^32 bits,
> that is 4 GiB of memory. Due to practical limitations (e.g. kernel
> needing some address space) usually a process won't have access to
> more than 3 GiB.

Roger,
are you using the icount allocation reduction patches previously posted=
?  They won't help if you need more than 3GB of address space, but they=
 definitely reduce the size of allocations and allow the icount data to=
 be swapped.  See the thread "[PATCH]: icount: Replace the icount list =
by a two-level tree".

>> If it is common knowledge, do you know of an upper limit (depending =
on fs size,
>> no. of inodes, etc)?
>>=20
>=20
> I vaguely remember some estimation of memory requirements of fsck
> being given somewhere, but I'm not able to find the posts now :(.

My rule of thumb is about 1 byte of memory per block in the filesystem,=
 for "normal" filesystems (i.e. mostly regular files, and a small fract=
ion of directories).  For a 3TB filesystem this would mean ~768MB of RA=
M.  One problem is that the current icount implementation allocates alm=
ost 2x the peak usage when it is resizing the array, hence the patch me=
ntioned above for filesystems with lots of directories and hard links.


Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
