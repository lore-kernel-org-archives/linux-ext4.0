From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup	blocks...
Date: Mon, 20 Apr 2009 10:51:45 -0500
Message-ID: <49EC9A11.1080105@redhat.com>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com> <gshfgl$o6m$1@ger.gmane.org> <20090420113534.GR19186@mit.edu> <alpine.LFD.2.00.0904201237500.17316@xpc17.ast.cam.ac.uk> <20090420124810.GT19186@mit.edu> <49EC8B97.6010308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeremy Sanders <jss@ast.cam.ac.uk>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54290 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240AbZDTPv4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 11:51:56 -0400
In-Reply-To: <49EC8B97.6010308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Theodore Tso wrote:
>> On Mon, Apr 20, 2009 at 12:43:37PM +0100, Jeremy Sanders wrote:
>>> It takes a day or two to do the sync. I've only done it twice (one with  
>>> the old kernel, once with the new fedora testing kernel) and it happened  
>>> both times. I'm afraid the statistics are rather low number here.
>>>
>>> I did a different faster test (just copying my home directory lots of  
>>> times), but I wasn't able to get it to fail. That test didn't use much  
>>> disk space, however. Maybe it's worth just dd'ing a few TB of data onto  
>>> the device and seeing whether that fails.
>>>
>>> I didn't reboot this time - I did last time. I just unmounted the file  
>>> system and fsckd it. The filesystem is 8.2TB and the data is around 
>>> 2.5TB.
> 
> I think trying a filesystem with just under 8T would be a useful test too.

One other question - do you make use of xattrs on this filesystem?

In case it's not obvious we are very interested in this reproducible
testcase, thank you for being so willing to provide feedback and testing
....

-Eric
