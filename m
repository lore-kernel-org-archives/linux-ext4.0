From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Filesystem testing
Date: Thu, 06 Feb 2014 22:48:41 -0600
Message-ID: <52F465A9.5030004@redhat.com>
References: <1391642427.40742.YahooMailNeo@web141002.mail.bf1.yahoo.com> <52F2ECD9.90909@redhat.com> <1391656365.52699.YahooMailNeo@web141005.mail.bf1.yahoo.com> <52F30211.2070705@redhat.com> <1391728596.39450.YahooMailNeo@web141003.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Mark Brown <ntdeveloper2002@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbaBGEsn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Feb 2014 23:48:43 -0500
In-Reply-To: <1391728596.39450.YahooMailNeo@web141003.mail.bf1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/6/14, 5:16 PM, Mark Brown wrote:
> Thanks for all the answers Eric:-)
> 
> I did have one question, and this was more related to ext3, and possible to xfstests.
> 
> Is there a test suite for ext3 that tests the various corruption
> issues, bugs that have been detected, and has other tests as well?
> Kind of a suite that is run everytime a change is made. I know its a
> question about a very old filesys, if I should direct my question
> elsewhere, do let me know. Maybe the generic in xfstests is enough
> for that, I couldnt find ext3 specific tests for the harness anywhere
> else. Is there a separate Redhat test suite (assuming ext3 was being
> maintained by RH)?
> 
> Is xfstests for ext4 basically used for ext4 for the question I asked
> about ext3 above?

we do still support & help with ext3, yes - and xfstests is still useful
for that.   It does not cover every bugfix, but the generic/shared
xfstests still have fairly decent generic ext3 coverage.

One could always write more tests if interested.  :)

-Eric

> Thanks.
> 
> 
> 
> 
> 
> 
> 
> 
> On Wednesday, February 5, 2014 7:31 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 2/5/14, 9:12 PM, Mark Brown wrote:
>> Thanks Eric.
>>
>> I am looking at the README here:
>> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=blob_plain;f=README;hb=HEAD
>>
>>
>> Is this what you are referring to? It doesnt seem to have much information about the tests.
> 
> Well, no, that's true.  There's no great summary of the tests; buit each test in tests/*/???
> should have at least a brief description at the top.
> 
> There's also a tests/*/group file which has keywords for each test, so you can do
> i.e. ./check -g stress to run all tests tagged with "stress"
> 
>> Should I look here?
>> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=tree;f=tests;h=a8535b21d5b45a7653bc0f4e2774d3b94871ba2e;hb=HEAD
> 
> well, there you can see the entire history of changes, so ... sure!  :)
> 
>>
>> I did have some questions:-)
>>
>> 1. Do the tests do operations other than the POSIX operations? I see
>> different directories for xfs etc, which would imply it does some
>> filesys specific calls?
> 
> yes; it's just a test harness, it can test whatever we like.
> 
> Some of the xfs tests do test xfs-specific operations.  Ditto for ext4 tests.
> Other tests are more generic.
> 
>> 2. There are some other test tools like Iozone which have similar
>> functionality. Wanted to understand what the differences would be, in
>> using xfstests as opposed to them?
> 
> iozone is a benchmark, not a test suite.  It measures performance, not correctness.
> 
>> 3. is xfstests more of a test suite geared for developers? Is it something a QA org can use
> 
> Our QA organization makes good use of it, as do others.  So, sure.
> 
> And best of all it's open source so if your organization comes across
> a bug, you can submit a testcase, and the bug should never(tm) happen again.
> 
>> 4. What I am looking for is a tool which I can use to stress the file
>> system a lot, do different operations etc, and make sure the data
>> written and metadata and the filesys itself is consistent by
>> verifying it at the end. You mentioned testing IO failures as well
>> and consistency is checked at the end. If you can point me to a few
>> tests that do the stress test and IO failures for the generic case,
>> that would really help, just to make sure i dont misunderstand the
>> tests when I am looking through the sources.
> 
> Start by reading the tests themselves; for example, tests/generic/311:
> 
> # Run various fsync tests with dm flakey in freeze() mode and non freeze()
> # mode. The idea is that we do random writes and randomly fsync and verify that
> # after a fsync() followed by a freeze()+failure or just failure that the file
> # is correct.  We remount the file system after the failure so that the file
> # system can do whatever cleanup it needs to and md5sum the file to make sure
> # it matches hat it was before the failure.  We also fsck to make sure the file
> # system is consistent.
> 
> -Eric
> 
>> Thanks:-)
>>
>>   
>>
>>
>>
>> On Wednesday, February 5, 2014 6:01 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 2/5/14, 5:20 PM, Mark Brown wrote:
>>> As an aside, I looked at xfstests, from what I could gather, it was
>>> started only for xfs, but there is ongoing work to make it work with
>>> ext4(and thus other posix FS?). If someone can point me to the
>>> documentation for xfstests and what it does, that would help. I could
>>> not find much.
>>
>> xfstests has gone pretty far beyond just xfs at this point - it's seen
>> heavy use on ext2/3/4 as well as btrfs in the past several years.
>>
>> There is a README in the git repo; did you have specific questions?
>>
>> We have a lot of tests in there; some are general stress tests, some
>> are specific regression tests, and the body of tests is always growing.
>>
>> Some test IO failures, as well.  File system consistency is checked after
>> each test.  Etc...
>>
>> -Eric
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

