From: Brad Figg <brad.figg@canonical.com>
Subject: Re: Ubuntu Ext4 regression testing
Date: Wed, 12 Sep 2012 19:04:18 -0700
Message-ID: <50513F22.3040201@canonical.com>
References: <50511241.2090603@canonical.com> <5051142D.1050603@redhat.com> <5051177E.6000903@canonical.com> <505126D4.5030106@redhat.com> <50512BB1.5010605@canonical.com> <50513C1A.9020504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44420 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab2IMCE0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Sep 2012 22:04:26 -0400
In-Reply-To: <50513C1A.9020504@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/12/2012 06:51 PM, Eric Sandeen wrote:
> On 9/12/12 7:41 PM, Brad Figg wrote:
> 
>> Eric,
>>
>> Thanks for taking the time to point this out. We will adjust our testing accordingly.
>> We initially tried to run xfstest against ext2, ext3, ext4, xfs and btrfs. We are also
>> trying to get these tests to run on several different kernel versions as you can
>> see from our test results. We were running into issues on different kernels and various
>> file-systems while getting our act together, we did this as a band-aid.
> 
> I see.
> 
>> I accept that we have some things to learn w.r.t. running this test suite. We will work
>> to run the xfstests "as is" without any outside "intelligence". We do recognise that
>> is a dynamic set of tests that people are adding to regularly.
>>
>> I am not attempting to get just a series of "pass" results. If that were my goal
>> I could accomplish it much easier and would not have engaged with the community
>> on the mailing list. We want to help where we can and will accept constructive
>> criticism.
> 
> Sorry, it sounds like I came across too strong there - it was just a little worrying to see failing or problematic tests disabled or otherwise artificially restricted.
> 
> I'm actually very excited to see you setting up ongoing, public testing using xfstests, I think it'll be a great benefit, especially if there's a way to see a particular test's results across several kernel versions and/or filesystems and/or architectures, so that patterns of failure can emerge.
> 
> If you find that xfstests is missing some feature or behavior which would facilitate testing in the automated environment, please do let us know what you need - or send patches.  :)
> 
> Thanks,
> -Eric
> 
>> Brad
>>
> 

No harm, no foul. We really don't mind constructive criticism. We are also
eager to get this setup and running. We will try to contribute more than
just running tests.

I do want to point out that we are using the xfstests which is a snapshot
in autotest. We do also look at the latest xfstests in the official xfstests
repo and add it in when we see a delta. We will also work with the autotest
maintainers to stay more up-to-date with xfstests.

Thanks,
Brad
-- 
Brad Figg brad.figg@canonical.com http://www.canonical.com
