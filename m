From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: tune2fs and setting noatime as a default mount options
Date: Fri, 29 Aug 2014 10:33:05 -0500
Message-ID: <54009D31.70703@redhat.com>
References: <16b17d3bf6a5952c3f20a8644be22c58@admin.virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Tomasz Chmielewski <mangoo@wpkg.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbaH2PdF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Aug 2014 11:33:05 -0400
In-Reply-To: <16b17d3bf6a5952c3f20a8644be22c58@admin.virtall.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/28/14, 5:12 PM, Tomasz Chmielewski wrote:
> I'd like to set noatime as a default mount option for a filesystem:
> 
> # tune2fs -o noatime /dev/sdb1
> tune2fs 1.42.9 (4-Feb-2014)
> Invalid mount option set: noatime

Right, the manpage doesn't list that as supported under "-o".

> Is there a reason why noatime can't be set as a default mount option? Thinking of all these USB connected devices where it would be handy.

I haven't looked, but I'm guessing it's because noatime is a vfs-level switch, and by the time the ext4 superblock is getting read and processed during mount, that chance has passed.

Just to keep things complicated and confusing ;) there's a different mechanism to do this as well:

# tune2fs -E mount_opts=noatime /dev/sdc1

which succeeds; however, this fails to be parsed at mount time:

[  118.384020] EXT4-fs (sdc1): failed to parse options in superblock: noatime

for the same reasons, I guess.  The documentation could certainly be better...

-Eric
