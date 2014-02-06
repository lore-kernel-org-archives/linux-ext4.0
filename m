From: Mark Brown <ntdeveloper2002@yahoo.com>
Subject: Re: Filesystem testing
Date: Thu, 6 Feb 2014 15:16:36 -0800 (PST)
Message-ID: <1391728596.39450.YahooMailNeo@web141003.mail.bf1.yahoo.com>
References: <1391642427.40742.YahooMailNeo@web141002.mail.bf1.yahoo.com> <52F2ECD9.90909@redhat.com> <1391656365.52699.YahooMailNeo@web141005.mail.bf1.yahoo.com> <52F30211.2070705@redhat.com>
Reply-To: Mark Brown <ntdeveloper2002@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm12-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.140]:34081 "EHLO
	nm12-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301AbaBFXXE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Feb 2014 18:23:04 -0500
In-Reply-To: <52F30211.2070705@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for all the answers Eric:-)

I did have one question, and this was more related to ext3, and possibl=
e to xfstests.

Is there a test suite for ext3 that tests the various corruption issues=
, bugs that have been detected, and has other tests as well? Kind of a =
suite that is run everytime a change is made. I know its a question abo=
ut a very old filesys, if I should direct my question elsewhere, do let=
 me know. Maybe the generic in xfstests is enough for that, I couldnt f=
ind ext3 specific tests for the harness anywhere else. Is there a separ=
ate Redhat test suite (assuming ext3 was being maintained by RH)?

Is xfstests for ext4 basically used for ext4 for the question I asked a=
bout ext3 above?

Thanks.








On Wednesday, February 5, 2014 7:31 PM, Eric Sandeen <sandeen@redhat.co=
m> wrote:
On 2/5/14, 9:12 PM, Mark Brown wrote:
> Thanks Eric.
>=20
> I am looking at the README here:
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Dxfs/cmds/xfstests.git;a=3Db=
lob_plain;f=3DREADME;hb=3DHEAD
>=20
>=20
> Is this what you are referring to? It doesnt seem to have much inform=
ation about the tests.

Well, no, that's true.=A0 There's no great summary of the tests; buit e=
ach test in tests/*/???
should have at least a brief description at the top.

There's also a tests/*/group file which has keywords for each test, so =
you can do
i.e. ./check -g stress to run all tests tagged with "stress"

> Should I look here?
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Dxfs/cmds/xfstests.git;a=3Dt=
ree;f=3Dtests;h=3Da8535b21d5b45a7653bc0f4e2774d3b94871ba2e;hb=3DHEAD

well, there you can see the entire history of changes, so ... sure!=A0 =
:)

>=20
> I did have some questions:-)
>=20
> 1. Do the tests do operations other than the POSIX operations? I see
> different directories for xfs etc, which would imply it does some
> filesys specific calls?

yes; it's just a test harness, it can test whatever we like.

Some of the xfs tests do test xfs-specific operations.=A0 Ditto for ext=
4 tests.
Other tests are more generic.

> 2. There are some other test tools like Iozone which have similar
> functionality. Wanted to understand what the differences would be, in
> using xfstests as opposed to them?

iozone is a benchmark, not a test suite.=A0 It measures performance, no=
t correctness.

> 3. is xfstests more of a test suite geared for developers? Is it some=
thing a QA org can use

Our QA organization makes good use of it, as do others.=A0 So, sure.

And best of all it's open source so if your organization comes across
a bug, you can submit a testcase, and the bug should never(tm) happen a=
gain.

> 4. What I am looking for is a tool which I can use to stress the file
> system a lot, do different operations etc, and make sure the data
> written and metadata and the filesys itself is consistent by
> verifying it at the end. You mentioned testing IO failures as well
> and consistency is checked at the end. If you can point me to a few
> tests that do the stress test and IO failures for the generic case,
> that would really help, just to make sure i dont misunderstand the
> tests when I am looking through the sources.

Start by reading the tests themselves; for example, tests/generic/311:

# Run various fsync tests with dm flakey in freeze() mode and non freez=
e()
# mode. The idea is that we do random writes and randomly fsync and ver=
ify that
# after a fsync() followed by a freeze()+failure or just failure that t=
he file
# is correct.=A0 We remount the file system after the failure so that t=
he file
# system can do whatever cleanup it needs to and md5sum the file to mak=
e sure
# it matches hat it was before the failure.=A0 We also fsck to make sur=
e the file
# system is consistent.

-Eric

> Thanks:-)
>=20
>=A0=20
>=20
>=20
>=20
> On Wednesday, February 5, 2014 6:01 PM, Eric Sandeen <sandeen@redhat.=
com> wrote:
> On 2/5/14, 5:20 PM, Mark Brown wrote:
>> As an aside, I looked at xfstests, from what I could gather, it was
>> started only for xfs, but there is ongoing work to make it work with
>> ext4(and thus other posix FS?). If someone can point me to the
>> documentation for xfstests and what it does, that would help. I coul=
d
>> not find much.
>=20
> xfstests has gone pretty far beyond just xfs at this point - it's see=
n
> heavy use on ext2/3/4 as well as btrfs in the past several years.
>=20
> There is a README in the git repo; did you have specific questions?
>=20
> We have a lot of tests in there; some are general stress tests, some
> are specific regression tests, and the body of tests is always growin=
g.
>=20
> Some test IO failures, as well.=A0 File system consistency is checked=
 after
> each test.=A0 Etc...
>=20
> -Eric
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html

>=20

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
