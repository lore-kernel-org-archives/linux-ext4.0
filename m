From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC] ext4: block reservation allocation
Date: Mon, 27 Feb 2012 21:36:53 +0800
Message-ID: <CAGBYx2ZMfx1ved0saUrnf5=7Y10Wt5BMiw76zgqY327cb569Fg@mail.gmail.com>
References: <20120227090901.GA13953@gmail.com>
	<alpine.LFD.2.00.1202271234250.5597@dhcp-27-109.brq.redhat.com>
	<20120227131829.GA14666@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56233 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab2B0Ngx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 08:36:53 -0500
Received: by obcva7 with SMTP id va7so5483717obc.19
        for <linux-ext4@vger.kernel.org>; Mon, 27 Feb 2012 05:36:53 -0800 (PST)
In-Reply-To: <20120227131829.GA14666@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 27, 2012 at 9:18 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Mon, Feb 27, 2012 at 01:00:07PM +0100, Lukas Czerner wrote:
> We encounter a problem in our product system. In a 2TB sata disk, the
> file can be divided into two categories. One is index file, and another
> is block file. The average size of index files is about 128k and will
> increase as time goes on. The size of block files is 70M and they are
> created by fallocate(2). Thus, index file is allocated at the end of the
> disk. When application starts up, it needs to load all of index files
> into memory. So it costs too much time. If we can allocate index files
> at the beginning of the disk, we will cut down the startup time and
> increase the service time of this application.
>
> Therefore, I think that it might be as a generic mechanism to provide
> other users that have the similar requirement.
Hi There,

   Some filesystems allocate faster blocks for metadata.  IMHO, we can
reserve faster blocks as possible as we can, and allocate faster
blocks for the files which have some flag set.   The flag is also can
be inherited from directory.

Yongqiang.
>
> Regards,
> Zheng
>
-- 
Best Wishes
Yongqiang Yang
