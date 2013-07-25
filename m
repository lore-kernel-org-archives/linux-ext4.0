From: Dhaval Giani <dgiani@mozilla.com>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Thu, 25 Jul 2013 11:16:06 -0400
Message-ID: <51F14136.30409@mozilla.com>
References: <1374699833.7083.2.camel@localhost> <20130724233628.GD3641@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, tglek@mozilla.com,
	vdjeric@mozilla.com, glandium@mozilla.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130724233628.GD3641@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/24/2013 07:36 PM, J=C3=B6rn Engel wrote:
> On Wed, 24 July 2013 17:03:53 -0400, Dhaval Giani wrote:
>> I am posting this series early in its development phase to solicit s=
ome
>> feedback.
> At this state, a good description of the format would be nice.

Sure. The format is quite simple. There is a 20 byte header followed by=
=20
an offset table giving us the offsets of 16k compressed zlib chunks (Th=
e=20
16k is the default number, it can be changed with the use of szip tool,=
=20
the kernel should still decompress it as that data is in the header). I=
=20
am not tied to the format. I used it as that is what being used here. M=
y=20
final goal is the have the filesystem agnostic of the compression forma=
t=20
as long as it is seekable.

>
>> We are implementing transparent decompression with a focus on ext4. =
One
>> of the main usecases is that of Firefox on Android. Currently libxul=
=2Eso
>> is compressed and it is loaded into memory by a custom linker on
>> demand. With the use of transparent decompression, we can make do
>> without the custom linker. More details (i.e. code) about the linker=
 can
>> be found at https://github.com/glandium/faulty.lib
> It is not quite clear what you want to achieve here.

To introduce transparent decompression. Let someone else do the=20
compression for us, and supply decompressed data on demand  (in this=20
case a read call). Reduces the complexity which would otherwise have to=
=20
be brought into the filesystem.

>    One approach is
> to create an empty file, chattr it to enable compression, then write
> uncompressed data to it.  Nothing in userspace will ever know the fil=
e
> is compressed, unless you explicitly call lsattr.
>
> If you want to follow some other approach where userspace has one
> interface to write the compressed data to a file and some other
> interface to read the file uncompressed, you are likely in a world of
> pain.
Why? If it is going to only be a few applications who know the file is=20
compressed, and read it to get decompressed data, why would it be=20
painful? What about introducing a new flag, O_COMPR which tells the=20
kernel, btw, we want this file to be decompressed if it can be. It can=20
fallback to O_RDONLY or something like that? That gets rid of the chatt=
r=20
ugliness.

> Assuming you use the chattr approach, that pretty much comes down to
> adding compression support to ext4.  There have been old patches for
> ext2 around that never got merged.  Reading up on the problems
> encountered by those patches might be instructive.

Do you have subjects for these? When I googled for ext4 compression, I=20
found http://code.google.com/p/e4z/ which doesn't seem to exist, and=20
checking in my LKML archives gives too many false positives.

Thanks!
Dhaval
