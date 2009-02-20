From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: kernel BUG at fs/ext4/extents.c:2738!
Date: Fri, 20 Feb 2009 14:40:31 -0600
Message-ID: <499F153F.2000502@redhat.com>
References: <1235115642.22702.2.camel@localhost.localdomain>	 <499ECF5C.7020509@redhat.com> <1235155713.22702.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49098 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbZBTUki (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Feb 2009 15:40:38 -0500
In-Reply-To: <1235155713.22702.25.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Friedrich Berendsen wrote:
> ...I haven't noticed  before, but before that message few more lines
> where recorded, which makes sense with the BUG line. Also, running
> fsck.ext4 on that filesystem I always got a Segment fault at an specific
> point, which it is impossible to fix. I'm in a process to remove files
> from that filesystem, as soon it finish I can run fsck again and send
> the result. Meanwhile, when removing files, rm stuck at a certain inode,
> which caused the first BUG message.

please stop w/ the file removal for a moment, and see if you can make an
e2image of the filesystem which reproduces the e2fsck problem ....

-Eric
