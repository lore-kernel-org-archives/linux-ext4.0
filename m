From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs - possible regression between 1.42.7 and 1.42.8
Date: Mon, 29 Jul 2013 12:14:43 -0500
Message-ID: <51F6A303.4090008@redhat.com>
References: <20130729083941.GG28871@pcnci.linuxbox.cz> <51F694B6.90901@redhat.com> <20130729163838.GI11816@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab3G2RO6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jul 2013 13:14:58 -0400
In-Reply-To: <20130729163838.GI11816@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/29/13 11:38 AM, Theodore Ts'o wrote:
> On Mon, Jul 29, 2013 at 11:13:42AM -0500, Eric Sandeen wrote:
>>
>> Ted, these are the same ones I saw, plus one I think (working on getting
>> all the info).
>>
>> I don't think it's a regression, because:
>>
>> commit e79a9395b382e831c125d000d2bf16ba4b6253d4
>> Author: Theodore Ts'o <tytso@mit.edu>
>> Date:   Sun Mar 31 20:34:24 2013 -0400
>>
>>     tests: add more tests for off-line resizing
>>
>> and:
>>
>> $ git describe --contains e79a9395b382e831c125d000d2bf16ba4b6253d4
>> v1.42.8~31
>>
>> the tests were only added in the last release.  Running the same tests
>> on older releases most likely breaks as well.
> 
> Well, they would almost certainly break on older releases because of
> bugs due to bugs that were fixed in 1.42.8.  :-)

...or not ;)

> Let me be more precise; these tests aren't failing for me when I run
> build and run "make check" on pristine 1.42.8 version of e2fsprogs on
> Debian Stable.  So it's likely that the test is doing something that
> is specific to Red Hat systems.  It may stil be turning up a bug that
> for some reason we're not seeing on Debian systems.  
> 
> We are using the e2fsck binary built in the tree as the source of test
> bits for the resize test.  I'm guessing that it is substantially
> smaller or bigger when built on Red Hat systems?!?

Something along those lines.

> Could you modify tests/script/resize to capture a copy of the
> constructed file system before we start running resize2fs on it so I
> can try reproducing it on my end?

Yes, getting to it ...

> 					- Ted
> 
> P.S.  Hmm, for some reason the size of the e2fsck binary must be
> *substantially* smaller on Red Hat systems.  What configure options
> are you using?

oh we just symlink it to /bin/true ;)  (KIDDING)

Hm, it's currently this in the specfile:

%configure --enable-elf-shlibs --enable-nls --disable-uuidd --disable-fsck \
           --disable-e2initrd-helper --disable-libblkid --disable-libuuid \
           --with-root-prefix=/usr

and %configure pulls in other stuff as well - let's see, here's the full cmdline:

+ ./configure --build=s390x-redhat-linux-gnu --host=s390x-redhat-linux-gnu --program-prefix= --disable-dependency-tracking --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc --datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib64 --libexecdir=/usr/libexec --localstatedir=/var --sharedstatedir=/var/lib --mandir=/usr/share/man --infodir=/usr/share/info --enable-elf-shlibs --enable-nls --disable-uuidd --disable-fsck --disable-e2initrd-helper --disable-libblkid --disable-libuuid --with-root-prefix=/usr

(!)

-Eric

> Looking at my log, it shrinks the file system to:
> 
> r_1024_small_bg.log:The filesystem on /tmp/e2fsprogs-tmp.RE74xl is now 1341 blocks long.
> 
> and then
> 
> r_1024_small_bg.log:The filesystem on /tmp/e2fsprogs-tmp.RE74xl is now 1215 blocks long.
> 
> On your log, it shrinks the filesystem to 1191 blocks and then 1111 blocks.
> 
> On my system with default configure options, the size of the e2fsck
> binary is 1124k.  It sounds like the size of your compiled e2fsck
> binary is approximately 100k smaller?
> 

