From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] default max mount count to unused
Date: Fri, 22 Jan 2010 11:35:01 -0700
Message-ID: <CC1F3E6D-A4B3-42C5-A71C-259DBA73CC4C@sun.com>
References: <4B5785A5.2010505@redhat.com>
 <F348497E-C9B1-49D3-920B-5AF98CBDDD98@sun.com>
 <20100122013735.GB21263@thunk.org> <4B59E38E.906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu, ext4 development <linux-ext4@vger.kernel.org>,
	Bill Nottingham <notting@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>,
	LVM Mailing List <linux-lvm@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57414 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab0AVSfI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jan 2010 13:35:08 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o0MIZ7aw003215
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jan 2010 10:35:07 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KWN00I00USRX800@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Fri,
 22 Jan 2010 10:35:07 -0800 (PST)
In-reply-to: <4B59E38E.906@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-01-22, at 10:42, Eric Sandeen wrote:
> tytso@mit.edu wrote:
>> On Thu, Jan 21, 2010 at 05:22:55PM -0700, Andreas Dilger wrote:
>>> Alasdair, any chance you can include this script into the LVM  
>>> package?
>>>
>>> Ted, this should really be added to e2fsprogs, and the e2croncheck
>>> script removed.  The existing e2croncheck script is broken in a
>>> number of ways (e.g. the force check timestamp 19000101 is invalid,
>>> the email reporting doesn't work because "$RPT-EMAIL" is never set)
>>> and is less functional in other ways (it doesn't remove stale
>>> snapshots in case of an interrupted script, it doesn't check
>>> multiple LVs, etc).
>>
>> Sure, I'd be happy to include this to e2fsprogs.  I'm not sure which
>> distro package should be installing it, but we can leave that up to
>> the distro maintainers.
>
> Last time around, we all seemed to think it should be in the lvm
> tools (though I don't remember exactly why - probably because it's
> really not ext*-specific at all)

Sure, but since there is only a semi-functional version in e2fsprogs  
we may as well replace it with a working one.

> It got forwarded to the LVM list, agk asked if anyone wanted to
> clean it up & take ownership of it, and that was the end.  :(


I guess I wasn't on that email.  I've gone ahead and fixed up the  
current script to be functional (including testing of failed-fsck  
email, force-fsck on next boot, stale snapshot cleanup, etc) so you  
may as well chalk me up as the maintainer for now.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

