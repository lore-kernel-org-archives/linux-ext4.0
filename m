From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: delalloc fragmenting files?
Date: Wed, 07 Nov 2007 14:53:09 -0600
Message-ID: <473225B5.2020103@redhat.com>
References: <20071026221938.GV3042@webber.adilger.int> <4728ED3B.1060407@redhat.com> <47291F62.3000008@gmail.com> <4729EEB2.9090406@redhat.com> <472A2384.2010001@redhat.com> <472AE644.1040102@gmail.com> <472B453F.8010608@redhat.com> <472E1114.7060206@gmail.com> <472F54EE.9030904@redhat.com> <4730C660.5020800@redhat.com> <20071107203716.GI3966@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>,
	Alex Tomas <bzzz.tomas@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbXKGUxO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Nov 2007 15:53:14 -0500
In-Reply-To: <20071107203716.GI3966@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Nov 06, 2007  13:54 -0600, Eric Sandeen wrote:
>> Hmm bad news is when I add uninit_groups into the mix, it goes a little
>> south again, with some out-of-order extents.  Not the end of the world,
>> but a little unexpected?

> I think part of the issue is that by default the groups marked BLOCK_UNINIT
> are skipped, to avoid dirtying those groups if they have never been used
> before.  This policy could be changed in the mballoc code pretty easily if
> you think it is a net loss.  Note that the size of the extents is large
> enough (120MB or more) that some small reordering is probably not going
> to affect the performance in any meaningful way.

You're probably right; on the other hand, this is about the simplest
test an allocator could wish for - a single-threaded large linear write
in big IO chunks.

In this case it's probably not a big deal; I do wonder how it might
affect the bigger picture though, with more writing threads, aged
filesystems, and the like.  Just thought it was worth pointing out, as I
started looking at allocator behavior in the simple/isolated/unrealistic
:) cases.

-Eric
