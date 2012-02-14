From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [SOLVED] (was "Re: Restoring filenames from partly damaged ext4-filesystem")
Date: Mon, 13 Feb 2012 19:25:08 -0500
Message-ID: <CAGpXXZKra-GJji_Y96kYGHLKCuabqNskoq2aSsx8OB6dB279YQ@mail.gmail.com>
References: <6D9A985A8374004AA880FD5D70B2D3C449AE04494A@ABGEX73E.FSC.NET> <20120213155146.GA17061@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Maar, Roberto" <roberto.maar@ts.fujitsu.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58743 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726Ab2BNAZi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 19:25:38 -0500
Received: by obcva7 with SMTP id va7so7319267obc.19
        for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2012 16:25:38 -0800 (PST)
In-Reply-To: <20120213155146.GA17061@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 13, 2012 at 10:51 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Feb 13, 2012 at 11:00:21AM +0100, Maar, Roberto wrote:
>> Everyone has a good backup, and no one destroy its files and file sy=
stems.
>
> If only that were true. =A0:-)
>
> Of course the developers who can do a good job writing recovery
> programs are smart enough to do regular backups. =A0This is why tools
> like extundelete and ext4magic generally don't get a lot of volunteer=
s
> to help with documentation and development.
>
> But you'd be amazed how many people contact me, or the ext4 list, or
> the ext3-users list, asking for help, and who obviously had _not_ bee=
n
> doing regular backups. =A0:-(
>
>>
>> One of the problems of ext4magic, of course, no English documentatio=
n.
>> But at the moment is the one man show, and my English is a disaster.
>> The world would laugh at it. I need some help for translation.
>> Proofread, for a native speaker with technical understanding a few m=
inutes work,
>> for me ...
>> We'll see, I try
>
> Well, I can certainly call for help, and see if there are folks who
> would be interested in helping you with the translation and
> creating/improving the English documentation
>
> And now that I know about it, I'll certainly be pointing people at it=
=2E
>
> Thanks for creating it!
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted

I took a minute and tried to put together a opensuse package for
ext4magic in my home directory for testing.

https://build.opensuse.org/package/show?package=3Dext4magic&project=3Dh=
ome%3Agregfreemyer%3ATools-for-forensic-boot-cd

I haven't tried to patch the source, but at present it has some
compile errors that keep OBS from publishing it even from a home
directory.

=3D=3D=3D=3D
I: Program returns random data in a function
E: ext4magic no-return-in-nonvoid-function hard_link_stack.c:87
E: ext4magic no-return-in-nonvoid-function imap_search.c:362
E: ext4magic no-return-in-nonvoid-function magic_block_scan.c:203, 1028=
, 249

I: A function uses a 'return;' statement, but has actually a value
   to return, like an integer ('return 42;') or similar.
W: ext4magic voidreturn ext4magic.c:888

I: Program is using implicit definitions of functions getting
   pointers or implemented by macros. These functions need to use their
   correct prototypes to allow correct argument passing on e.g. x86_64 =
=2E
     - Implicit memory/string functions need #include <string.h>.
     - Implicit *printf functions need #include <stdio.h>.
     - Implicit *printf functions need #include <stdio.h>.
     - Implicit *read* functions need #include <unistd.h>.
     - Implicit *recv* functions need #include <sys/socket.h>.
W: ext4magic implicit-pointer-decl journal.c:754

=3D=3D=3D=3D=3D

I think just the E: errors are mandatory to fix for OBS to publish the
package, but I'm not sure about that.

Roberto, if you think you'll come out with a cleaner build in the next
couple weeks, I won't bother to patch up those errors.

Thanks
Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
