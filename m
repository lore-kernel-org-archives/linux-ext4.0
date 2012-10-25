From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: Automatic setting of {INODE,BLOCK}_UNINIT flags
Date: Thu, 25 Oct 2012 20:54:09 +0800
Message-ID: <20121025125408.GA17378@gmail.com>
References: <1351149943-4827-1-git-send-email-tracek@redhat.com>
 <CAGBYx2bU=G0X4GDZSjznnn12yAxJXs=RWn_x1EvHM8RGbkdk0A@mail.gmail.com>
 <alpine.LFD.2.00.1210251138100.24674@dhcp-1-104.brq.redhat.com>
 <CAGBYx2YbtPmCc5=OEKZoLHDj90oboUfBXBXm+BMVF-XMS8z0kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Tomas Racek <tracek@redhat.com>, linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:55720 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab2JYMm4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2012 08:42:56 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so770506dak.19
        for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2012 05:42:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAGBYx2YbtPmCc5=OEKZoLHDj90oboUfBXBXm+BMVF-XMS8z0kg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 25, 2012 at 07:39:06PM +0800, Yongqiang Yang wrote:
> >
> > So my question is, why do you think this might not make sense in no
> > journal mode ? Maybe I am missing something.
> Yep, advantage is obvious, in no journal mode, if we delete a file
> which is the last inode in a block group, and the uninit flag of inode
> bitmap is flused to disk and directory referring the inode is not
> flushed,  I don't know how fsck handles the situation currently.  If
> fsck handles the situation, everything is ok. I meant maybe we should
> check fsck too.

Hi Yongqiang,

It seems that it couldn't happen whether it is in no journal mode or
journal mode.  When a file is deleted, the dir entry will be updated
firstly, and then the block will be freed.  So the block is freed after
the dir entry is updated.  So when the last inode is freed, the dir
entry must be flushed to the disk.  Am I missing something?

Regards,
Zheng
