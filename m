From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: mkfs.ext4 vs. e2fsck discard oddities
Date: Thu, 08 Mar 2012 11:48:23 -0500
Message-ID: <4F58E2D7.205@ubuntu.com>
References: <4F4D1020.5060204@redhat.com> <alpine.LFD.2.00.1202290801510.4926@dhcp-27-109.brq.redhat.com> <34CA4C93-194F-45F3-9A94-E181A7DFEBCE@mit.edu> <alpine.LFD.2.00.1203010804410.6491@dhcp-27-109.brq.redhat.com> <20120301143834.GA30578@thunk.org> <alpine.LFD.2.00.1203011540180.6491@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:7229 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab2CHQsZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Mar 2012 11:48:25 -0500
In-Reply-To: <alpine.LFD.2.00.1203011540180.6491@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/1/2012 9:54 AM, Lukas Czerner wrote:
> Well, it is not default right ? So the user should better know what is
> he doing. Moreover it is not like it is end of the world when we do not
> provide that option, since SSD's will handle over provisioning to some
> extent even without slowdown, and as for thin-provisioned devices you
> should know why you're overriding defaults and what it means for you.
>
> Anyway, if people really want this another option to discard all the
> block groups including those UNINIT ones, I guess I can not resist that
> :). '-E discard_all' maybe ?

I think the option is a little more generic than discard.  The uninit 
groups are not discarded because they are not checked in the first 
place.  A bad group descriptor checksum will force the group to be 
checked, and thus discarded as well.  I think what is needed is an 
option to trigger the same thing: force all groups to be checked, even 
if they are uninit and have good descriptor checksums.  Maybe -E thorough?

