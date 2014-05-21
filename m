From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: OpenPosix test case mmap_11-4 fails in ext4 filesystem
Date: Wed, 21 May 2014 17:18:24 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405211715360.2114@localhost.localdomain>
References: <537C4A2F.8040402@cn.fujitsu.com> <alpine.LFD.2.00.1405211413370.2114@localhost.localdomain> <20140521141203.GB1501@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-25939799-1400685507=:2114"
Cc: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org, chrubis@suse.cz
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbaEUPSc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2014 11:18:32 -0400
In-Reply-To: <20140521141203.GB1501@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-25939799-1400685507=:2114
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 21 May 2014, Theodore Ts'o wrote:

> Date: Wed, 21 May 2014 10:12:03 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>, linux-ext4@vger.kernel.org,
>     chrubis@suse.cz
> Subject: Re: OpenPosix test case mmap_11-4 fails in ext4 filesystem
> 
> On Wed, May 21, 2014 at 02:55:12PM +0200, Lukáš Czerner wrote:
> > > 
> > > Recently I met the mmap_11-4 fails when running LTP in RHEL7.0RC. Attached is a
> > > test program to reproduce this problem, which is written by Cyril.  Uncommenting the
> > > msync() makes the test succeed in old linux distribution, such as RHEL6.5GA, but
> > > fails in RHEL7.0RC.
> > 
> > please contact you Red Hat support to triage the issue within Red
> > Hat.
> 
> This is a valid bug report which applies to upstream ext4.  It also
> applies to tmpfs, by the way.

I am not disputing it, but since he seems to be using RHEL I am
asking for the triage with Red Hat support.

Thanks!
-Lukas
--8323328-25939799-1400685507=:2114--
