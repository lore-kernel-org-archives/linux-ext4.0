From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v3] ext4: Prevent race while waling extent tree
Date: Mon, 19 Nov 2012 12:11:35 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211191211280.24659@dhcp-1-104.brq.redhat.com>
References: <1352732245-30132-1-git-send-email-lczerner@redhat.com> <1352794923-28555-1-git-send-email-lczerner@redhat.com> <CA+a=Yy6pi5rUv2GJtsvH1=O+WAawWg03S_ORpVfwnVzYa4tPqA@mail.gmail.com> <alpine.LFD.2.00.1211131304030.3577@localhost> <20121113141911.GA7472@X61>
 <20121113185104.GC1282@lenny.home.zabbo.net> <alpine.LFD.2.00.1211151714520.27888@dhcp-1-104.brq.redhat.com> <20121119032430.GB24414@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-515253542-1353323498=:24659"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	Zach Brown <zab@redhat.com>, Peng Tao <bergwolf@gmail.com>,
	linux-ext4@vger.kernel.org, dmonakhov@openvz.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab2KSLLo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Nov 2012 06:11:44 -0500
In-Reply-To: <20121119032430.GB24414@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-515253542-1353323498=:24659
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sun, 18 Nov 2012, Theodore Ts'o wrote:

> Date: Sun, 18 Nov 2012 22:24:30 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Zach Brown <zab@redhat.com>, Peng Tao <bergwolf@gmail.com>,
>     linux-ext4@vger.kernel.org, dmonakhov@openvz.org
> Subject: Re: [PATCH v3] ext4: Prevent race while waling extent tree
> 
> On Thu, Nov 15, 2012 at 05:39:06PM +0100, Lukáš Czerner wrote:
> > You're both right. The code have to be reorganized. The
> > ext4_ext_fiemap_cb() is ugly as hell, but luckily that will be
> > resolved with extent status tree patches from Zheng Liu, however the
> > indirection in ext4_ext_walk_space() and the callback business
> > is also pointless.
> 
> Hi Lukas,
> 
> Is your patch going to be dependent on whether the extent status tree
> patches are applied?
> 
> If so, you might want to develop your patch versus the ext4 git tree's
> master branch, which includes the extent status patches currently
> queued for the next merge window.
> 
> Thanks!!
> 
> 					- Ted

Yes, there is a small conflict. I'll base it on top of the ext4 git
tree.

Thanks!
-Lukas
--571107329-515253542-1353323498=:24659--
