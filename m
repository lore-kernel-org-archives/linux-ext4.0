From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Is ext2 freezable?
Date: Fri, 05 Jun 2015 11:47:25 -0500
Message-ID: <5571D29D.1040505@redhat.com>
References: <EE124450C0AAF944A40DD71E61F878C99CE2C3@SINEX14MBXC418.southpacific.corp.microsoft.com> <20140918191736.GC19520@thunk.org> <EE124450C0AAF944A40DD71E61F878C99D4840@SINEX14MBXC418.southpacific.corp.microsoft.com> <loom.20150605T132316-300@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
To: Syed Imtiaz <sihussain2@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734AbbFEQr1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2015 12:47:27 -0400
In-Reply-To: <loom.20150605T132316-300@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/5/15 6:23 AM, Syed Imtiaz wrote:
> Dexuan Cui <decui <at> microsoft.com> writes:
>> Hi Ted,
>> Thanks very much for the clarification!
>>
>> And thanks a lot for implementing this -- I've seen the patches you 
> sent out
>> several hours ago.
>>
>> IMO it's useful to have such compatibility, e.g.,
>> Hyper-V guest has a fsfreeze-based feature to back up the data; the 
> feature
>> works fine for ext4 partition, but Ubuntu's installer can create /boot
>> of ext2 partition by default and hence the feature can't work:
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1362574
>>
>> I believe the bug will go away after Ubuntu integrates your patches.
>>
>> Thanks!
> 
> 
> Hi Theodore,
>   CAn you please tell me where can i find these patches. I am unable to 
> locate it. or the steps the install it ?
> Do we have to install it every system that doesnt support fsfreeze in 
> the ext2 fs.

To be clear, the patches were only for ext2-mounted-with-ext4.ko.
The native ext2 driver freezes w/o any problem.

The upstream commit is here:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=bb04457

and has been fixed upstream since kernel v3.18

-Eric
