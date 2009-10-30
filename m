From: Andreas Dilger <adilger@sun.com>
Subject: Re: EXT4 >16TB resize2fs support
Date: Fri, 30 Oct 2009 09:17:57 -0600
Message-ID: <00E93B30-1C92-4185-8E80-B4AD840183B5@sun.com>
References: <150c16850910291454j18db2729m572dc0fe22658f1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42480 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbZJ3PRz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 11:17:55 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n9UFHvBL005741
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2009 08:18:00 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KSC007001ZMZY00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 30 Oct 2009 08:17:57 -0700 (PDT)
In-reply-to: <150c16850910291454j18db2729m572dc0fe22658f1e@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-10-29, at 15:54, Justin Maggard wrote:
> What is the current expected status of resize2fs support with 64-bit
> filesystems?  Specifically, expanding from <16TB to >16TB.  I'm using
> the latest code from pu, and seeing some odd things.  I'm not sure
> what the 64bit feature flag does exactly, but is the transition not
> handled properly?

This isn't supposed to work at all, and in fact should be disabled.
Firstly, the group descriptors are not big enough to hold the 64-bit
block addresses unless the filesystem was originally formatted > 16TB.

Secondly, the resize code has not been made 64-bit clean.

> So... what is expected to work at this point, and what is expected to
> be broken with the resize process?  Any idea why my fs was shrunk down
> to 2.2TB when it was supposed to grow to 18TB?


The filesystem size was truncated to a 32-bit value.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

