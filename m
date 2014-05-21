From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: OpenPosix test case mmap_11-4 fails in ext4 filesystem
Date: Wed, 21 May 2014 17:06:06 -0500
Message-ID: <537D234E.7060304@redhat.com>
References: <537C4A2F.8040402@cn.fujitsu.com> <alpine.LFD.2.00.1405211413370.2114@localhost.localdomain> <20140521141203.GB1501@thunk.org> <20140521150619.GA5459@rei.suse.cz> <20140521185824.GB8868@thunk.org> <20140521212003.GA7493@rei.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Luk???? Czerner <lczerner@redhat.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: chrubis@suse.cz, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbaEUWGW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2014 18:06:22 -0400
In-Reply-To: <20140521212003.GA7493@rei.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/21/14, 4:20 PM, chrubis@suse.cz wrote:
> Hi!
>> There is a pretty large amount of overlap between LTP and xfstests,
>> and xfstests are what most of the file system developers are using,
>> and we have developed a lot of automated test automation which means
>> running xfstests is very easy and convenient.  For example:
>>
>> 	https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/README
>>
>> The ability for me to build a kernel and then with a single command,
>> "kvm-xfstests smoke", do a quick verification in about 30 minutes, is
>> very convenient.
> 
> LTP is automated to a degree where you run single script and get a file
> with list of failed testcases later. We do not have any kind of kvm
> integration though.
> 
>> As I recall, ltp was integrated with autotest, and my experience with
>> autotest at multiple companies is if anything, worse than ltp's
>> reputation.  (I considered ltp to be mostly harmless, albeit not
>> particularly useful, whereas I considered autotest to be activetly
>> harmful to engineer productivity.)
> 
> The autotest integration is not a part of the LTP at all. I remember
> seeing it somewhere but I've never used it/looked at the code.
> 
> LTP has it's own script and testdriver to run testcases, but given that
> LTP tests are just binaries that are mostly self-contained it's not
> doing much more than starting a test, writing logfiles and killing
> lefover processes (if the tests fails to collect them itself). I will
> not pretend that it's clean and well designed code but at least it works
> fine (as a matter of fact I've started to work on redesigning/rewriting
> it from scratch some time ago).
> 
>> Anyway, it's already the case that most of the useful file-system
>> specific bits of LTP has been cherry picked into xfstests, and I
>> suspect it will be a lot easier to get a few additional LTP test cases
>> added into xfstests, than it will be to convince a large number of
>> file system developers that they should (a) try to figure out how to
>> integrate LTP into their test harnesses, and (b) how to avoid
>> duplicating tests which xfstests are already running.
> 
> Well I can personally help with (a).
> 
> The test in question here (mmap_11-4) is a part of the Open Posix
> Testsuite that continues to live in LTP. The whole testsuite runs in
> about 30 minutes and covers most of the POSIX interfaces in ~1600
> testcases.
> 
> Then there is a syscalls testsuite which covers, in addition to the
> POSIX specs, some of the Linux specific interfaces too. The runtime is
> about 15 minutes for ~1030 testcases.
> 
> I guess that we can filter filesystem related syscalls quite easily. The
> overlap would take more work though. In LTP we have mostly conformance
> testcases and some stress testcases. I'm not much familiar with xfstests
> and its coverage.
> 
> And we have a more tests that may be interesting to fs maintaners, there
> are aio testcases (which are likely covered by xfstests allready), some
> fs stress tests, ...
> 

FWIW, I don't think there's any real compelling reason to migrate existing
LTP tests into xfstests.  Maybe LTP folks just need to do a better job of
pitching LTP to filesystem developers, as we did with xfstests.  :)

-Eric
