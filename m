From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 01/10] ext4: balloc: Fixed coding style issue
Date: Wed, 17 Oct 2012 16:27:39 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1210171609040.30534@dhcp-1-104.brq.redhat.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com> <alpine.LFD.2.00.1210171359270.30534@dhcp-1-104.brq.redhat.com> <CAFLxGvzKGJ0-Mau+21sSi+A5WKtbvF=+YxrKxVFta0Ecx6y_Jg@mail.gmail.com>
 <CANBXnMkoFo1HdQZkOq0HR4aLX_LObXB2=mEpiHBwK2CSK_hCKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-653617409-1350484062=:30534"
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
	=?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab2JQO1n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Oct 2012 10:27:43 -0400
In-Reply-To: <CANBXnMkoFo1HdQZkOq0HR4aLX_LObXB2=mEpiHBwK2CSK_hCKA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-653617409-1350484062=:30534
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 17 Oct 2012, Adil Mujeeb wrote:

> Date: Wed, 17 Oct 2012 19:35:40 +0530
> From: Adil Mujeeb <mujeeb.adil@gmail.com>
> To: richard -rw- weinberger <richard.weinberger@gmail.com>,
>     Lukáš Czerner <lczerner@redhat.com>
> Subject: Re: [PATCH 01/10] ext4: balloc: Fixed coding style issue
> 
> Hi,
> 
> On Wed, Oct 17, 2012 at 5:43 PM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
> > On Wed, Oct 17, 2012 at 2:05 PM, Lukáš Czerner <lczerner@redhat.com> wrote:
> >> On Wed, 17 Oct 2012, Adil Mujeeb wrote:
> >>
> >>> Date: Wed, 17 Oct 2012 00:42:56 +0530
> >>> From: Adil Mujeeb <mujeeb.adil@gmail.com>
> >>> To: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
> >>>     linux-kernel@vger.kernel.org
> >>> Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
> >>> Subject: [PATCH 01/10] ext4: balloc: Fixed coding style issue
> >>>
> >>> Fixed checkpatch.pl reported ERRORs
> >>
> >> Hi Adil,
> >>
> >> let me ask you something. How useful do you think those changes are ?
> >> Have you learned anything by creating those patches ?
> 
> I am newbie. I just thought of starting with cleanup thing. I know
> that from functionality point of view, I am not adding anything but
> thought if it helps in coding guideline compliance and uniformity of
> code.
> Now I understand that this is not required. In future, I will avoid
> submitting such patches.

So you've learned something :). But seriously such patches are
causing more problems than it solves. It's perfectly fine to clean
up the code in the area you're changing anyway, but making coding
style patches just for a sake of it is not usually useful. Moreover
it is not useful for you as well, because you're not going to learn
anything.

There are plenty of real problem to be solved, but it actually
involves reading and understanding the code first.

Just for example:

 - get familiar with xfstests
 - there might still be problems with unified ext4 driver where
   we might use options not suited for respective file system
 - there are still issues with bigalloc
 - I suspect that there will be some problems with file system >16TB
 - recently there has been some reports from bigzilla.kernel.org
 - or you can just read the code, trying to understand how it works
   and soon or later you will find something to fix :) I am sure
   about that.

Maybe someone else have better suggestions...

Good luck!
-Lukas

> 
> >>
> >> Just to clarify why I am asking such weird questions. It's not one of
> >> those sneer questions, I would really like to know.
> >>>  linux-3.7-rc1/fs/ext4/balloc.c |    8 ++++----
> >
> > The really sad thing is that this patch does not even apply because
> > the path is malformed.
> 
> I am sorry, seems I am missing something. I tried with my local repo
> and it worked :(
> Its not the right place to ask, so I'll look what went wrong with the patches.
> 
> Rgds,
> Adil
> 
> >
> > --
> > Thanks,
> > //richard
> 
--571107329-653617409-1350484062=:30534--
