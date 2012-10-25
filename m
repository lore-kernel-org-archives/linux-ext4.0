From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Automatic setting of {INODE,BLOCK}_UNINIT flags
Date: Thu, 25 Oct 2012 15:59:38 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1210251555310.14460@dhcp-1-104.brq.redhat.com>
References: <1351149943-4827-1-git-send-email-tracek@redhat.com> <CAGBYx2bU=G0X4GDZSjznnn12yAxJXs=RWn_x1EvHM8RGbkdk0A@mail.gmail.com> <alpine.LFD.2.00.1210251138100.24674@dhcp-1-104.brq.redhat.com> <CAGBYx2YbtPmCc5=OEKZoLHDj90oboUfBXBXm+BMVF-XMS8z0kg@mail.gmail.com>
 <20121025125408.GA17378@gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-1712698633-1351173586=:14460"
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	=?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	Tomas Racek <tracek@redhat.com>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161121Ab2JYN7r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2012 09:59:47 -0400
In-Reply-To: <20121025125408.GA17378@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-1712698633-1351173586=:14460
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 25 Oct 2012, Zheng Liu wrote:

> Date: Thu, 25 Oct 2012 20:54:09 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: Yongqiang Yang <xiaoqiangnk@gmail.com>
> Cc: Luká¨ Czerner <lczerner@redhat.com>, Tomas Racek <tracek@redhat.com>,
>     linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] ext4: Automatic setting of {INODE,BLOCK}_UNINIT flags
> 
> On Thu, Oct 25, 2012 at 07:39:06PM +0800, Yongqiang Yang wrote:
> > >
> > > So my question is, why do you think this might not make sense in no
> > > journal mode ? Maybe I am missing something.
> > Yep, advantage is obvious, in no journal mode, if we delete a file
> > which is the last inode in a block group, and the uninit flag of inode
> > bitmap is flused to disk and directory referring the inode is not
> > flushed,  I don't know how fsck handles the situation currently.  If
> > fsck handles the situation, everything is ok. I meant maybe we should
> > check fsck too.
> 
> Hi Yongqiang,
> 
> It seems that it couldn't happen whether it is in no journal mode or
> journal mode.  When a file is deleted, the dir entry will be updated
> firstly, and then the block will be freed.  So the block is freed after
> the dir entry is updated.  So when the last inode is freed, the dir
> entry must be flushed to the disk.  Am I missing something?

I think you're right. Doing this the other way around would be a bug
regardless on this patch.

Thanks!
-Lukas

> 
> Regards,
> Zheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--571107329-1712698633-1351173586=:14460--
