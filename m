From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 settings in an embedded system
Date: Fri, 16 Nov 2012 09:56:44 -0600
Message-ID: <50A6623C.6050601@redhat.com>
References: <C0489DC3A08C21449F8FE865472DC75204834F08@BUDMLVEM03.e2k.ad.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Ohlsson, Fredrik (GE Healthcare, consultant)"
	<Fredrik.Ohlsson@ge.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab2KPP4s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Nov 2012 10:56:48 -0500
In-Reply-To: <C0489DC3A08C21449F8FE865472DC75204834F08@BUDMLVEM03.e2k.ad.ge.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/14/12 4:41 AM, Ohlsson, Fredrik (GE Healthcare, consultant) wrote:
> Hi,
> I would like to have advice regarding features and options.
> I am working with an embedded system equipped with an IDE Flash Disk
> and the ext4 filesystem. I have identified 3 problems that I would
> like to solve in our product. The power is abruptly turned off from
> time to time, this has sometimes resulted in broken Superblock
> (inode8) and empty files with size 0 bytes. It also happens that file
> changes is not committed to disk even if minutes pass before a power
> loss. This is very undesirable and expensive in our case, we are
> searching for a solution or a workaround to the problems.

> List with my problems I like to solve:
> 1. Broken Superblock (inode8).
> 2. Empty files, size 0.
> 3. Very long auto commit times, several minutes with default settings.
> 
> 
> Is ext4 a bad choice for an embedded system with I 1Gb IDE Flash Disk
> and Debian 2.6.32-5-686? Should we change filesystem?
> 
> I am planning to set the mount flags: barrier=1, commit=1 and
> data=journal, is this the way to go with an embedded system and ext4?

When you say "with barrier=1", were you using barrier=0 (or "nobarrier")
before?

If you have disabled barriers explicitly, just start with re-enabling
them.  If your software is doing all the right data integrity syscalls,
then that is probably enough.

-Eric

> Is there more ext4 options/settings I can use to get an embedded
> system reliable when a power loss occurs?
> 
> Best Regards
> 
> Fredrik Ohlsson
> Software Engineer
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

