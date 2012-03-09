From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: mkfs.ext4 vs. e2fsck discard oddities
Date: Fri, 09 Mar 2012 10:14:18 -0500
Message-ID: <4F5A1E4A.9060804@ubuntu.com>
References: <4F4D1020.5060204@redhat.com> <alpine.LFD.2.00.1202290801510.4926@dhcp-27-109.brq.redhat.com> <34CA4C93-194F-45F3-9A94-E181A7DFEBCE@mit.edu> <alpine.LFD.2.00.1203010804410.6491@dhcp-27-109.brq.redhat.com> <20120301143834.GA30578@thunk.org> <alpine.LFD.2.00.1203011540180.6491@dhcp-27-109.brq.redhat.com> <4F58E2D7.205@ubuntu.com> <alpine.LFD.2.00.1203090957190.4487@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:4337 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab2CIPOV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Mar 2012 10:14:21 -0500
In-Reply-To: <alpine.LFD.2.00.1203090957190.4487@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/9/2012 3:59 AM, Lukas Czerner wrote:
> Why would we try to check UNINIT groups with valid descriptor checksums
> ? I think that this problem will be solved with BLOCK_DISCARDED flag as
> we discussed with Ted in another thread. No need to have yet another
> option so it is win-win :)

Because not skipping a specific action on an uninitialized group ( 
discard ) is a specific case of the more general form of not skipping 
uninitialized groups.  I thought that it might sometimes be useful to 
actually verify the group is correct instead of trusting the uninit 
flag, especially if you are about to discard it.  Also any other things 
that are added in the future and skipped for uninit groups would not 
need yet another flag to specifically not skip that action, since it 
will be covered by the more general flag already.

Also the way the code was structured it looked like it would be much 
simpler to bypass the skip and do the full check of the uninit group 
than to modify it to discard the group even though checking it was skipped.



