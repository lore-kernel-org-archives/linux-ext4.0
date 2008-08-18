From: Andreas Dilger <adilger@sun.com>
Subject: Re: Bug in delayed allocation: really bad block layouts!
Date: Mon, 18 Aug 2008 03:50:12 -0700
Message-ID: <20080818105012.GP3040@webber.adilger.int>
References: <E1KSEkA-00009o-CV@closure.thunk.org> <489F2B38.3060104@redhat.com>
 <20080810182231.GB15353@mit.edu> <489F397A.1040709@redhat.com>
 <489F49B0.6020105@redhat.com> <20080811014646.GE15353@mit.edu>
 <489FCFD4.2050602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Kalpak Shah <Kalpak.Shah@sun.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:40051 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYHRKuP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Aug 2008 06:50:15 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7IAoFvv020489
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 03:50:15 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K5S00H01M0D7600@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 18 Aug 2008 03:50:15 -0700 (PDT)
In-reply-to: <489FCFD4.2050602@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 11, 2008  00:36 -0500, Eric Sandeen wrote:
> Theodore Tso wrote:
> > One of
> > the things I've been meaning to do is to clean up the output of
> > filefrag so that it's a bit easier to parse.  It's really stupid for
> > it to print "file is in extents format" over and over again...
> 
> I'm not really even sure why it should print it at all, ever, at least
> without -vvv or something.  (That's what I meant to filter the first
> time ;)  If the tool is to report layout I'm not sure the trivia about
> how the layout is tracked internally is all that interesting.  The
> fiemap patches for filefrag that print it out more as a table format,
> more like xfs_bmap does, should be a lot better.  But anyway...

Actually, the FIEMAP patches for filefrag provide a much nicer format
for the output, more like what xfs_bmap does.  For now it only does
this if requested with the "-e" option (--extents) but if Ted is not
adverse to changing the output format of filefrag we could make it the
default.

The whole Lustre patchset (against 1.40.11) is at
http://downloads.lustre.org/public/tools/e2fsprogs/latest/e2fsprogs-1.40.11-sun1-patches.tar.gz

but Kalpak or I can send just the FIEMAP one again if you are interested.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

