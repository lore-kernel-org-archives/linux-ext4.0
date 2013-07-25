From: Taras Glek <tglek@mozilla.com>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Thu, 25 Jul 2013 09:42:18 -0700
Message-ID: <51F1556A.20909@mozilla.com>
References: <1374699833.7083.2.camel@localhost> <20130724233628.GD3641@logfs.org> <51F14136.30409@mozilla.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
	linux-kernel@vger.kernel.org, tytso@mit.edu, vdjeric@mozilla.com,
	glandium@mozilla.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Dhaval Giani <dgiani@mozilla.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.corp.phx1.mozilla.com ([63.245.216.70]:38420 "EHLO
	smtp.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab3GYQvL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jul 2013 12:51:11 -0400
In-Reply-To: <51F14136.30409@mozilla.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Dhaval Giani wrote:
> On 07/24/2013 07:36 PM, J=C3=B6rn Engel wrote:
>> On Wed, 24 July 2013 17:03:53 -0400, Dhaval Giani wrote:
>>> I am posting this series early in its development phase to solicit =
some
>>> feedback.
>> At this state, a good description of the format would be nice.
>
> Sure. The format is quite simple. There is a 20 byte header followed=20
> by an offset table giving us the offsets of 16k compressed zlib chunk=
s=20
> (The 16k is the default number, it can be changed with the use of szi=
p=20
> tool, the kernel should still decompress it as that data is in the=20
> header). I am not tied to the format. I used it as that is what being=
=20
> used here. My final goal is the have the filesystem agnostic of the=20
> compression format as long as it is seekable.
>
>>
>>> We are implementing transparent decompression with a focus on ext4.=
 One
>>> of the main usecases is that of Firefox on Android. Currently libxu=
l.so
>>> is compressed and it is loaded into memory by a custom linker on
>>> demand. With the use of transparent decompression, we can make do
>>> without the custom linker. More details (i.e. code) about the linke=
r=20
>>> can
>>> be found at https://github.com/glandium/faulty.lib
>> It is not quite clear what you want to achieve here.
>
> To introduce transparent decompression. Let someone else do the=20
> compression for us, and supply decompressed data on demand  (in this=20
> case a read call). Reduces the complexity which would otherwise have=20
> to be brought into the filesystem.
The main use for file compression for Firefox(it's useful on Linux=20
desktop too) is to improve IO-throughput and reduce startup latency. In=
=20
order for compression to be a net win an application should be aware of=
=20
what is being compressed and what isn't. For example patterns for IO on=
=20
large libraries (eg 30mb libxul.so) are well suited to compression, but=
=20
SQLite databases are not.  Similarly for our disk cache: images should=20
not be compressed, but javascript should be. Footprint wins are useful=20
on android, but it's the increased IO throughput on crappy storage=20
devices that makes this most attractive.

In addition of being aware of which files should be compressed, Firefox=
=20
is aware of patterns of usage of various files it could schedule=20
compression at the most optimal time.

Above needs tie in nicely with the simplification of not implementing=20
compression at fs-level.
>
>>    One approach is
>> to create an empty file, chattr it to enable compression, then write
>> uncompressed data to it.  Nothing in userspace will ever know the fi=
le
>> is compressed, unless you explicitly call lsattr.
>>
>> If you want to follow some other approach where userspace has one
>> interface to write the compressed data to a file and some other
>> interface to read the file uncompressed, you are likely in a world o=
f
>> pain.
> Why? If it is going to only be a few applications who know the file i=
s=20
> compressed, and read it to get decompressed data, why would it be=20
> painful? What about introducing a new flag, O_COMPR which tells the=20
> kernel, btw, we want this file to be decompressed if it can be. It ca=
n=20
> fallback to O_RDONLY or something like that? That gets rid of the=20
> chattr ugliness.
This transparent decompression idea is based on our experience with=20
HFS+. Apple uses the fs-attribute approach. OSX is able to compress=20
application libraries at installation-time, apps remain blissfully=20
unaware but get an extra boost in startup perf.

So in Linux, the package manager could compress .so files, textual data=
=20
files, etc.
>
>> Assuming you use the chattr approach, that pretty much comes down to
>> adding compression support to ext4.  There have been old patches for
>> ext2 around that never got merged.  Reading up on the problems
>> encountered by those patches might be instructive.
>
> Do you have subjects for these? When I googled for ext4 compression, =
I=20
> found http://code.google.com/p/e4z/ which doesn't seem to exist, and=20
> checking in my LKML archives gives too many false positives.
>
> Thanks!
> Dhaval
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
