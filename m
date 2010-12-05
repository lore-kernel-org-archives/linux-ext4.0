From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [dm-devel] hunt for 2.6.37 dm-crypt+ext4 corruption?
Date: Sun, 5 Dec 2010 20:17:12 +0000
Message-ID: <AANLkTim_FgS0qWFhsHjeNKc9b_B0mcj_Aez-3sU2t0Yi@mail.gmail.com>
References: <4CF692D1.1010906@redhat.com>
	<AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
	<4CF6B3E8.2000406@redhat.com>
	<20101201212310.GA15648@redhat.com>
	<AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
	<20101204193828.GB13871@redhat.com>
	<AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com>
	<20101205100954.GA6564@fritha.org>
	<4CFB679D.5030900@redhat.com>
	<1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu>
	<20101205143316.GA9559@fritha.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Theodore Tso <tytso@mit.edu>,
	device-mapper development <dm-devel@redhat.com>,
	Jon Nelson <jnelson@jamponi.net>, htejun@gmail.com,
	Matt <jackdachef@gmail.com>, Mike Snitzer <snitzer@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	htd <htd@fancy-poultry.org>, linux-ext4@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Heinz Diehl <htd@fritha.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101205143316.GA9559@fritha.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Heinz,

On 5 December 2010 14:33, Heinz Diehl <htd@fritha.org> wrote:
> On 05.12.2010, Theodore Tso wrote:
>
>> As another thought, what version of GCC are people using who
>> are having difficulty? Could this perhaps be a compiler-related issue?
>
> htd@liesel:~> gcc -v
> Using built-in specs.
> Target: x86_64-suse-linux
> Configured with: ../configure --prefix=/usr --infodir=/usr/share/info
> --mandir=/usr/share/man --libdir=/usr/lib64 --libexecdir=/usr/lib64
> --enable-languages=c,c++,objc,fortran,obj-c++,java,ada
> --enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.3
> --enable-ssp --disable-libssp --with-bugurl=http://bugs.opensuse.org/
> --with-pkgversion='SUSE Linux' --disable-libgcj --disable-libmudflap
> --with-slibdir=/lib64 --with-system-zlib --enable-__cxa_atexit
> --enable-libstdcxx-allocator=new --disable-libstdcxx-pch
> --enable-version-specific-runtime-libs --program-suffix=-4.3
> --enable-linux-futex --without-system-libunwind --with-cpu=generic
> --build=x86_64-suse-linux
> Thread model: posix
> gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux)

A bit late to the party, but does memtest86 pass over multiple iterations?

Also, can you send an 'sudo lspci -vv', so we can check for
known-buggy controllers and bridges?

Thanks,
  Daniel
-- 
Daniel J Blueman
