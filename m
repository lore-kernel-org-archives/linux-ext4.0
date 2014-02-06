From: Mark Brown <ntdeveloper2002@yahoo.com>
Subject: Re: Filesystem testing
Date: Wed, 5 Feb 2014 19:12:45 -0800 (PST)
Message-ID: <1391656365.52699.YahooMailNeo@web141005.mail.bf1.yahoo.com>
References: <1391642427.40742.YahooMailNeo@web141002.mail.bf1.yahoo.com> <52F2ECD9.90909@redhat.com>
Reply-To: Mark Brown <ntdeveloper2002@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm49.bullet.mail.bf1.yahoo.com ([216.109.114.65]:30780 "EHLO
	nm49.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbaBFDTb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Feb 2014 22:19:31 -0500
In-Reply-To: <52F2ECD9.90909@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks Eric.

I am looking at the README here:
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Dxfs/cmds/xfstests.git;a=3Dblo=
b_plain;f=3DREADME;hb=3DHEAD


Is this what you are referring to? It doesnt seem to have much informat=
ion about the tests.

Should I look here?
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Dxfs/cmds/xfstests.git;a=3Dtre=
e;f=3Dtests;h=3Da8535b21d5b45a7653bc0f4e2774d3b94871ba2e;hb=3DHEAD


I did have some questions:-)

1. Do the tests do operations other than the POSIX operations? I see di=
fferent directories for xfs etc, which would imply it does some filesys=
 specific calls?
2. There are some other test tools like Iozone which have similar funct=
ionality. Wanted to understand what the differences would be, in using =
xfstests as opposed to them?
3. is xfstests more of a test suite geared for developers? Is it someth=
ing a QA org can use?
4. What I am looking for is a tool which I can use to stress the file s=
ystem a lot, do different operations etc, and make sure the data writte=
n and metadata and the filesys itself is consistent by verifying it at =
the end. You mentioned testing IO failures as well and consistency is c=
hecked at the end. If you can point me to a few tests that do the stres=
s test and IO failures for the generic case, that would really help, ju=
st to make sure i dont misunderstand the tests when I am looking throug=
h the sources.

Thanks:-)

=A0



On Wednesday, February 5, 2014 6:01 PM, Eric Sandeen <sandeen@redhat.co=
m> wrote:
On 2/5/14, 5:20 PM, Mark Brown wrote:
> As an aside, I looked at xfstests, from what I could gather, it was
> started only for xfs, but there is ongoing work to make it work with
> ext4(and thus other posix FS?). If someone can point me to the
> documentation for xfstests and what it does, that would help. I could
> not find much.

xfstests has gone pretty far beyond just xfs at this point - it's seen
heavy use on ext2/3/4 as well as btrfs in the past several years.

There is a README in the git repo; did you have specific questions?

We have a lot of tests in there; some are general stress tests, some
are specific regression tests, and the body of tests is always growing.

Some test IO failures, as well.=A0 File system consistency is checked a=
fter
each test.=A0 Etc...

-Eric

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
