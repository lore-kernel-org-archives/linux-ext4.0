From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2fsprogs: remove misleading argument from
	ext2fs_bg_flags_clear
Date: Wed, 02 Sep 2009 17:28:11 -0600
Message-ID: <20090902232811.GG4197@webber.adilger.int>
References: <4A9EE6E4.2000307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:59844 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbZIBX2A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 19:28:00 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n82NS2Gt001214
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 16:28:02 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPD00900AFCYN00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 02 Sep 2009 16:28:02 -0700 (PDT)
In-reply-to: <4A9EE6E4.2000307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 02, 2009  16:43 -0500, Eric Sandeen wrote:
> ext2fs_bg_flags_clear shouldn't take an unused bg_flags argument
> if its purpose is to clear -all- flags.  That just makes people
> like me call it for the wrong purpose ;)

I'd pointed this out when the code was originally submitted.
That said, I'd prefer a function which allows clearing
individual flags, rather than all of them.  It is possible to
call it with ~0 to clear all of the flags.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

