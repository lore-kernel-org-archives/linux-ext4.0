From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: RFC, 32-bit compat handlers for EXT4_IOC_GROUP_ADD
Date: Mon, 08 Dec 2008 10:31:03 -0600
Message-ID: <493D4BC7.1010903@redhat.com>
References: <49385BC5.2070703@redhat.com> <20081206010204.GY3186@webber.adilger.int> <20081206202409.GI1323@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60883 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbYLHQb2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Dec 2008 11:31:28 -0500
In-Reply-To: <20081206202409.GI1323@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, Dec 05, 2008 at 06:02:04PM -0700, Andreas Dilger wrote:
>>> How far out of "dev" are we?  I'm leaning towards saying "oh well, would
>>> have been nicer the other way" but going ahead and just putting the
>>> compat handler into the kernel.
>> I would be OK with changing to the "proper" struct layout.  Not being able
>> to resize with an older e2fsprogs + newer kernel isn't going to cause any
>> serious problems (unlike e.g. not being able to mount or e2fsck "/").
>>
>> If we are seriously worried about compatibility, we could add the compat
>> handler for 32-bit kernels (should have a different IOC number anyways
>> because of the struct size) and add some arbitrary check like:
>>
>> #ifdef LINUX_KERNEL_VERSION > KERNEL_VERSION(2,6,40)
>> #warning remove this old compat code
>> #endif
> 
> Given that a bunch of distro's have shipped e2fsprogs 1.41.x which we
> advertised as being ext4 compatibility, I think we need to keep the
> compatibility code.  If we want to add the complexity for the 32-bit
> side, with a 2-3 year timeout, that seems like a reasonable
> compromise.
> 
> 							- Ted

I tend to agree, unfortunately... I'll send the current compat patch,
then, and when/if I get motivated, add another cleaner interface+number
I guess...

-Eric
