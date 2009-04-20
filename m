From: Andreas Dilger <adilger@sun.com>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup	blocks...
Date: Mon, 20 Apr 2009 12:28:00 -0600
Message-ID: <20090420182800.GC3209@webber.adilger.int>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com>
 <gshfgl$o6m$1@ger.gmane.org> <20090420113534.GR19186@mit.edu>
 <alpine.LFD.2.00.0904201237500.17316@xpc17.ast.cam.ac.uk>
 <20090420124810.GT19186@mit.edu> <49EC8B97.6010308@redhat.com>
 <49EC9A11.1080105@redhat.com>
 <alpine.LFD.2.00.0904201652540.17316@xpc17.ast.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Jeremy Sanders <jss@ast.cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:37293 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbZDTS2U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Apr 2009 14:28:20 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3KISFTI009297
	for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2009 11:28:15 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIE00800WD7YJ00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 20 Apr 2009 11:28:15 -0700 (PDT)
In-reply-to: <alpine.LFD.2.00.0904201652540.17316@xpc17.ast.cam.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 20, 2009  16:53 +0100, Jeremy Sanders wrote:
> On Mon, 20 Apr 2009, Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> Theodore Tso wrote:
>>>> On Mon, Apr 20, 2009 at 12:43:37PM +0100, Jeremy Sanders wrote:
>>>>> It takes a day or two to do the sync. I've only done it twice (one with
>>>>> the old kernel, once with the new fedora testing kernel) and it happened
>>>>> both times. I'm afraid the statistics are rather low number here.
>>>>>
>>>>> I did a different faster test (just copying my home directory lots of
>>>>> times), but I wasn't able to get it to fail. That test didn't use much
>>>>> disk space, however. Maybe it's worth just dd'ing a few TB of data onto
>>>>> the device and seeing whether that fails.
>>>>>
>>>>> I didn't reboot this time - I did last time. I just unmounted the file
>>>>> system and fsckd it. The filesystem is 8.2TB and the data is around
>>>>> 2.5TB.
>>>
>>> I think trying a filesystem with just under 8T would be a useful test too.
>>
>> One other question - do you make use of xattrs on this filesystem?
>
> No.

If you use anything like SELinux or ACLs you would also (indirectly) be
using xattrs.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

