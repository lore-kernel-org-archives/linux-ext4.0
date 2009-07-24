From: Ron Johnson <ron.l.johnson@cox.net>
Subject: Re: ioctl32 (was Re: filefrag abort)
Date: Thu, 23 Jul 2009 19:34:32 -0500
Message-ID: <4A690198.4000904@cox.net>
References: <4A64E650.6020603@cox.net> <20090721020312.GL2416@mit.edu> <4A665E3F.7000109@cox.net> <4A666413.5030301@redhat.com> <20090722170152.GN4231@webber.adilger.int> <4A67EC3B.9060503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eastrmpop111.cox.net ([68.230.240.53]:52059 "EHLO
	eastrmpop111.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZGXBMY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jul 2009 21:12:24 -0400
Received: from eastrmimpo02.cox.net ([68.1.16.120])
          by eastrmmtao101.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20090724003433.DUIK22545.eastrmmtao101.cox.net@eastrmimpo02.cox.net>
          for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 20:34:33 -0400
In-Reply-To: <4A67EC3B.9060503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-07-22 23:51, Eric Sandeen wrote:
[snip]
> 
> I think adding COMPATIBLE_IOCTL(FS_IOC_FIEMAP); to fs/compat_ioctl.c
> should be enough, I'll try to get it tested tomorrow.

If the tarball/git tree can be installed under /usr/local, I'd be 
glad to test it too.

-- 
Scooty Puff, Sr
The Doom-Bringer
