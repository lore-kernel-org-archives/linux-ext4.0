From: Ding Dinghua <dingdinghua85@gmail.com>
Subject: Re: [RFC] Journal credits debugging (Was: Re: Bug#615998: ...)
Date: Sat, 2 Jul 2011 19:12:12 +0800
Message-ID: <CANf+_kJnFyTEVvPJj261rTzW+iD1c0D+SuJAn=Runufkt30J5Q@mail.gmail.com>
References: <BANLkTi=xXtnsBECOdSsC4_1bgnCrwsMb6g@mail.gmail.com>
	<37DE6F9F-E43F-4EB8-9A1D-6CDB59F90134@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33072 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab1GBLMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Jul 2011 07:12:14 -0400
Received: by pvg12 with SMTP id 12so3166113pvg.19
        for <linux-ext4@vger.kernel.org>; Sat, 02 Jul 2011 04:12:13 -0700 (PDT)
In-Reply-To: <37DE6F9F-E43F-4EB8-9A1D-6CDB59F90134@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/6/29 Andreas Dilger <adilger@dilger.ca>
>
> On 2011-06-29, at 1:10 AM, Amir Goldstein wrote:
> > I would like to suggest an approach that may help us track down the=
se
> > sort of bugs more easily.
> >
> > Add a new class_id argument to ext4_handle_dirty_metadata() and col=
lect
> > statistics of used credits per class_id.
> >
> > There are only so many types of journaled objects:
> > SUPER, GDT, BB, IB, ITB, IND, EXT, DATA, XATTR, QUOT...
> > So it shouldn't be a problem to save the statistics per handle.
> >
> > If you look at struct jbd2_journal_handle, you will find a bunch of=
 h_cow_XXX
> > fields intended as COW debugging counters.
> > We may as well turn these fields into a generic counters array, whi=
ch can
> > be used by either COW debugging or credits debugging code.
> >
> > This should be simple enough to implement and should provide
> > a more detailed report when buffer credits have run out.
> >
> > However, if we are going to modify all call sites of
> > ext4_handle_dirty_metadata(), it would be wise to also add an objec=
t_id
> > (or a better name) argument that will provide the group no. or inod=
e no.
> > or quota type, or any other id relevant for classification.
> >
> > We can use this information, along with where, line, handle, ino,
> > block_nr, buffer_credits and create a stable trace point in
> > __ext4_handle_dirty_metadata().
>
> One of the things I like about the ZFS/DMU transaction API is that in=
stead
> of the caller having to "just know" how many credits are needed to mo=
dify
> the filesystem, the caller specifies the inodes/directories that will=
 be
> modified, and if new inodes are allocated in a "declaration" step bef=
ore
> starting the transaction. =A0This allows the internal code to account=
 for the
> metadata will be modified, and avoids the knowledge of journal credit=
s for
> different update types all over the code.

Would you please give more details about this? I don't think it's
different from Jbd/Jbd2
at first glance

>
> Cheers, Andreas
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--
Ding Dinghua
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
