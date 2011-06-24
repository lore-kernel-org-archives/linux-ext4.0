From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: avoid eh_entries overflow before insert
 extent_idx
Date: Fri, 24 Jun 2011 10:39:31 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106241035490.5123@dhcp-27-109.brq.redhat.com>
References: <1308818837-5243-1-git-send-email-sanbai@taobao.com> <4E035453.8080808@redhat.com> <BANLkTinmwdXURNGw+OsMRST4x_S+z+R4Sw@mail.gmail.com> <BANLkTi=E5xZG6ey3FyDXV=-O7=+V6Mb2WQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1193546370-1308904775=:5123"
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab1FXIjp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jun 2011 04:39:45 -0400
In-Reply-To: <BANLkTi=E5xZG6ey3FyDXV=-O7=+V6Mb2WQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1193546370-1308904775=:5123
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 24 Jun 2011, Robin Dong wrote:

> 2011/6/24 Yongqiang Yang <xiaoqiangnk@gmail.com>:
> > On Thu, Jun 23, 2011 at 10:57 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> >> On 6/23/11 3:47 AM, Robin Dong wrote:
> >>> If eh_entries is equal to (or greater than) eh_max, the operation of
> >>> inserting new extent_idx will make number of entries overflow.
> >>> So check eh_entries before inserting the new extent_idx.
> >>
> >> Do you have any testcase you can share which shows this bug?
> > I am not sure if Robin has any test case.
> >
> > According to code, I think there is no bug case.  Because this
> > function is called by ext4_ext_split() and ext4_ext_split() is called
> > only if the index block has free space.
> >
> > I think the right logic should be as this patch shows, that is, we
> > should lookup the capacity before insertion.
> 
> Exactly!  :-)

Hi Robin, this is the reason why I asked you to provide better commit
description with better reasoning for this change. Since it is not
immediately clear from the patch itself why you did the change, it saves
time for everyone (just FYI for the next time:).

Thanks!
-Lukas
--8323328-1193546370-1308904775=:5123--
