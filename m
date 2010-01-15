From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [REPOST][PATCH][RFC] vfs: add message print mechanism for the
 mount/umount into the VFS layer
Date: Fri, 15 Jan 2010 17:31:50 +0900
Message-ID: <20100115173150.f64d6577.toshi.okajima@jp.fujitsu.com>
References: <20100114154837.734fff60.toshi.okajima@jp.fujitsu.com>
	<20100114081448.GI19799@ZenIV.linux.org.uk>
	<D69F3C0C-FC4A-4866-98BD-DE9558250A0B@sun.com>
	<20100115012421.GA28498@discord.disaster>
	<5E9FF033-5FD5-42B4-985B-C241F45746C1@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	"James C. Browne" <browne@cs.utexas.edu>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54084 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab0AOIv5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jan 2010 03:51:57 -0500
In-Reply-To: <5E9FF033-5FD5-42B4-985B-C241F45746C1@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 14 Jan 2010 23:36:25 -0500
Andreas Dilger <adilger@sun.com> wrote:

> However, it is doesn't make sense to me to suggest that people add random
> binary status messages to netlink at random times without any kind of
> planning or coordination, since it will just result in a mishmash of
> ad-hoc messages, tools, etc, that will be far worse than what we have
> today instead of improving what exists in /var/log/messages today.

My true purpose is to confirm time when a certain ext3 filesystem
was unmounted.
(We can confirm time when a certain ext3 filesystem was mounted because
ext3 filesystem prints the specific messages at mount. Therefore, to add "unmount"
message into ext3 satisfies my purpose. But to add the one into VFS layer is more
appropriate because we can distinguish the events (mount/unmount) for other
filesystems.)
-------------------------------------------------------------------------------------
Background:
I am an investigator of the root causes of my user incidents. When I investigated
a user's incident, I wanted to know whether a certain mounted ext3 filesystem
had been clearly unmounted or not. Because a certain problem could not occur if its
filesystem had been already unmounted. But now, there is no way to know whether
filesystems were unmounted after the event was done.
Owing to this reason, I want some mechanisms to know whether a certain filesystem
is clearly unmounted after such events was done.
Therefore, I proposed the additional print mechanism in VFS layer.
-------------------------------------------------------------------------------------
For such a purpose, I think the text message in /var/log/messages is more appropriate.

Regards,
Toshiyuki Okajima
