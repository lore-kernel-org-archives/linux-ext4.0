From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Filessystem corruptions while using rsnapshot
Date: Wed, 9 Sep 2009 23:42:23 +0200
Message-ID: <20090909214223.GB2011@phenom2.trippelsdorf.de>
References: <20090909133026.GA1965@phenom2.trippelsdorf.de>
 <4AA7BE69.7070406@redhat.com>
 <20090909172015.GA1980@phenom2.trippelsdorf.de>
 <4AA7E411.7070005@redhat.com>
 <20090909212925.GA2011@phenom2.trippelsdorf.de>
 <4AA81FB1.7000000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-144.synserver.de ([212.40.180.144]:1057 "HELO
	smtp-out-144.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752924AbZIIVmX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Sep 2009 17:42:23 -0400
Content-Disposition: inline
In-Reply-To: <4AA81FB1.7000000@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 09, 2009 at 04:35:45PM -0500, Eric Sandeen wrote:
> Markus Trippelsdorf wrote:
> > On Wed, Sep 09, 2009 at 12:21:21PM -0500, Eric Sandeen wrote:
> >> Markus Trippelsdorf wrote:
> >>> On Wed, Sep 09, 2009 at 09:40:41AM -0500, Eric Sandeen wrote:
> >>>> Markus Trippelsdorf wrote:
> >> ...
> >>
> >>>>> The bug is very simple to reproduce here. Just run rsnapshot several
> >>>>> times per day and you will eventually hit the problem.
> >>>> Could you provide a bzip2'd e2image -r of a corrupted filesystem for 
> >>>> analysis?
> >>> OK I've uploaded the file (~80 MB):
> >>> http://www.2shared.com/file/7681344/d19d7154/disc_e2image.html
> >>>
> >>> Hope it helps.
> >> Thanks, can't guarantee that the post-mortem will lead to the anwer but 
> >> it's worth a look.
> > 
> > I also took a look myself and it turned out that my maildir, which
> > contains the LKML messages of the last three months, is the root of the
> > problem. I can now reproduce the bug, by simply running (e.g.):
> > 
> > cp -al /var/backup/hourly.3/localhost/home/markus/.maildir/lkml/. /var/tmp/debug
> > 
> > where /var is mounted as: "/dev/sda1 on /var type ext4 (rw,noatime,commit=60)"
> > and /var/backup/hourly.3/localhost/ is a previous backup produced by rsnapshot.
> 
>  From the original post it wasn't quite clear; do you hit runtime 
> corruption, indicated by the kernel logs when the fs is mounted, and a 
> subsequent fsck also finds errors?
> 
> Just for completeness, if there are errors in the system logs, can you 
> post them here as well?

There are no errors in the system logs.
I only learned about this bug when a regular boot-time fsck was running that
printed the problems mentionted above.
-- 
Markus
