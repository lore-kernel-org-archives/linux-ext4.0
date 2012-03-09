From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: mkfs.ext4 vs. e2fsck discard oddities
Date: Fri, 9 Mar 2012 09:59:37 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203090957190.4487@dhcp-27-109.brq.redhat.com>
References: <4F4D1020.5060204@redhat.com> <alpine.LFD.2.00.1202290801510.4926@dhcp-27-109.brq.redhat.com> <34CA4C93-194F-45F3-9A94-E181A7DFEBCE@mit.edu> <alpine.LFD.2.00.1203010804410.6491@dhcp-27-109.brq.redhat.com> <20120301143834.GA30578@thunk.org>
 <alpine.LFD.2.00.1203011540180.6491@dhcp-27-109.brq.redhat.com> <4F58E2D7.205@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab2CII7o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Mar 2012 03:59:44 -0500
In-Reply-To: <4F58E2D7.205@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 8 Mar 2012, Phillip Susi wrote:

> On 3/1/2012 9:54 AM, Lukas Czerner wrote:
> > Well, it is not default right ? So the user should better know what is
> > he doing. Moreover it is not like it is end of the world when we do not
> > provide that option, since SSD's will handle over provisioning to some
> > extent even without slowdown, and as for thin-provisioned devices you
> > should know why you're overriding defaults and what it means for you.
> > 
> > Anyway, if people really want this another option to discard all the
> > block groups including those UNINIT ones, I guess I can not resist that
> > :). '-E discard_all' maybe ?
> 
> I think the option is a little more generic than discard.  The uninit groups
> are not discarded because they are not checked in the first place.  A bad
> group descriptor checksum will force the group to be checked, and thus
> discarded as well.  I think what is needed is an option to trigger the same
> thing: force all groups to be checked, even if they are uninit and have good
> descriptor checksums.  Maybe -E thorough?
> 

Why would we try to check UNINIT groups with valid descriptor checksums
? I think that this problem will be solved with BLOCK_DISCARDED flag as
we discussed with Ted in another thread. No need to have yet another
option so it is win-win :)

Thanks!
-Lukas
