From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: ext4 undeletion question
Date: Tue, 28 Apr 2009 13:55:07 -0400
Message-ID: <87f94c370904281055s630e55adsba1e4968f782a822@mail.gmail.com>
References: <alpine.DEB.2.00.0904281037240.5262@zest.trausch.us>
	 <20090428161106.GB24043@mit.edu>
	 <20090428132609.7628940e@zest.trausch.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	mike-mobile@trausch.us
To: "Michael B. Trausch" <mbt@zest.trausch.us>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:52060 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762336AbZD1RzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 13:55:09 -0400
Received: by yw-out-2324.google.com with SMTP id 5so391208ywb.1
        for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 10:55:08 -0700 (PDT)
In-Reply-To: <20090428132609.7628940e@zest.trausch.us>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 28, 2009 at 1:26 PM, Michael B. Trausch <mbt@zest.trausch.u=
s> wrote:
> On Tue, 28 Apr 2009 12:11:06 -0400
> Theodore Tso <tytso@mit.edu> wrote:
>> There is the program "ext3grep" which will look for older versions o=
f
>> the directory and inode table blocks in the journal. =A0This can wor=
k,
>> but unfortunately I don't think it's been extended to understand abo=
ut
>> the ext4 extent data structure.
>
> Eh. =A0Thanks for the mention... gave it a shot, but it seems to fail
> nearly immediately:
>
> Tuesday, 2009-Apr-28 at 13:21:41 - mbt@zest - Linux v2.6.29.1
> Ubuntu Jaunty:[0-9/10014-0]:undel> sudo ext3grep --restore-all /dev/z=
estvg/home-retain-undelete
> Running ext3grep version 0.10.1
> WARNING: I don't know what EXT3_FEATURE_COMPAT_EXT_ATTR is.
> ext3grep: ext3grep.cc:119: void run_program(): Assertion `be2le(journ=
al_super_block.s_header.h_magic) =3D=3D 0xc03b3998U' failed.
> zsh: abort =A0 =A0 =A0sudo ext3grep --restore-all /dev/zestvg/home-re=
tain-undelete
>
> I guess that means it won't work on an ext4 fs. =A0:-)
>
> I did create a snapshot of it using LVM (durr, I didn't think of that
> before) so the FS is preserved as it was... I just don't know how to =
go
> about digging through it to get the directory that I deleted out.
> Hopefully I can figure that out before terribly long, as I am stuck
> until I do...
>
> =A0 =A0 =A0 =A0--- Mike

Mike,

WinHex is a commercial product for doing undeletes that supports
Ext2/3, ReiserFS, Reiser4, and UFS.  You need the Specialist version
to handle ext3.  It might handle ext4.

If not and assuming you have a very ext3 like on disk structure, you
might be able to force it to work anyway.

http://www.x-ways.com/winhex/index-m.html

You can try out the demo and see if you can see if it works.  I don't
know what the limitations of the demo version are.

Also, the support forum is run by one of the main coders (Stefan) of
the software, so he is extremely knowledgeable.   I think he also owns
part of the company, but I'm not sure about that.

Given that ext4 is the coming thing, he is likely to be willing to
work with you to extend his product at least as far as needed to
support you.  Notice he has Reiser4 support which shows he keeps the
software pretty leading edge.

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
