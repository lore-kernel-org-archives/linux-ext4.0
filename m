From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/2] ext4: journal all modifications in
 ext4_xattr_set_handle
Date: Sat, 07 Nov 2009 12:22:13 -0700
Message-ID: <5103C29A-FE60-4AA7-8D41-30C21D2CC84E@sun.com>
References: <4AF4A334.1000304@redhat.com> <4AF4A49F.8030005@redhat.com>
 <55C0D494-12AD-4EF7-8C35-411B2B5151EF@sun.com> <20091107023341.GF26342@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43389 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbZKGTWK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Nov 2009 14:22:10 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nA7JMF0V004146
	for <linux-ext4@vger.kernel.org>; Sat, 7 Nov 2009 11:22:15 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KSR00G006ROJD00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Sat,
 07 Nov 2009 11:22:15 -0800 (PST)
In-reply-to: <20091107023341.GF26342@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-06, at 19:33, Theodore Tso wrote:
> On Fri, Nov 06, 2009 at 05:22:51PM -0700, Andreas Dilger wrote:
>> On 2009-11-06, at 15:35, Eric Sandeen wrote:
>>> Oh, and for those who haven't been following the bug, big
>>> thanks to Chris Mason for helping to look into this and coming
>>> up with the debugging patch that made it obvious...
>>
>> It would be great, IMHO, to have this debugging patch submitted to
>> the kernel also, and enabled under a CONFIG option.
>
> The debugging patch is only safe when the file system's block size ==
> page size.  I suppose we could leave a warning in Kconfig that the
> debugging option is only safe to be used when all of the file systems
> in the system have a 4k (or whatever the page size happens to be)
> block size, but it's probably better to clean up the patch so that
> it's only enabled on a mount option, and then only if the file system
> block size is the same as the page size.

Yes, definitely, but this covers about 90% of the filesystems in use,
so I don't see it as a big limitation.

>> I'd also be interested to see the "write shadow buffer to journal"
>> one-line patch that was discussed in the bug.
>
> Which patch are you referring to?


In bugzilla there was a comment from Chris:

         "Eric helped prove this is the case by testing a patch that  
always
          crcs and writes a stable duplicate of the metadata buffer  
instead
          of the metadata buffer itself (a one liner since the log  
code was
          already setup for this)."

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

