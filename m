From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: grub / ext4 compatibility problem?
Date: Wed, 17 Jun 2009 17:40:01 +0200
Message-ID: <200906171740.02101.bzolnier@gmail.com>
References: <200906171648.59573.bzolnier@gmail.com> <200906171707.58004.bzolnier@gmail.com> <4A3909BA.5030007@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:43137 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZFQPes (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jun 2009 11:34:48 -0400
Received: by ewy6 with SMTP id 6so609894ewy.37
        for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2009 08:34:49 -0700 (PDT)
In-Reply-To: <4A3909BA.5030007@redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wednesday 17 June 2009 17:20:26 Eric Sandeen wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 17 June 2009 16:46:57 Eric Sandeen wrote:
> >> Bartlomiej Zolnierkiewicz wrote:
> >>> Hi,
> >>>
> >>> I've run into a really peculiar problem today..
> >> ...
> >>
> >>> This is on Fedora 11 system (I upgraded from Fedora 10 few days ago) with
> >>> all updates and ext3 migrated (per HOWTO on ext4 wiki) to ext4 yesterday.
> >>>
> >>> Is this something worth people's attention or should I just try to run fsck
> >>> manually?
> >>
> >> is /boot ext4?  F11's grub doesn't yet understand ext4, as mentioned in
> >> the releasenotes.  I hope to remedy that soon but in the F11 devel
> >> cycle, other bugs of the oopsing & corrupting kind were more pressing...
> > 
> > I see it now, in my case there is no separate /boot partition.. :)
> > 
> > Thanks Eric & sorry for the noise.
> 
> No problem, sorry I didn't get grub going before F11 released :)

Hm, upon looking at the ext4 patch for the grub I think that including it
can't make the situation worse.  It is quite compact/clean patch and grub
cannot ever access such fs in write mode (AFAICS from the quick look)?

Though I can imagine that comments like this one:

+      /* map extents enabled logical block number to physical fs on-dick block number */

may significantly decrease confidence in the changes. :)

Thanks.
Bart
