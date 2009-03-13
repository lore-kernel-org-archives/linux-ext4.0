From: Frank Mayhar <fmayhar@google.com>
Subject: Re: ext4_mb_generate_buddy and double-free errors
Date: Thu, 12 Mar 2009 20:22:13 -0700
Message-ID: <1236914533.731.15.camel@bobble.smo.corp.google.com>
References: <1236904175.731.12.camel@bobble.smo.corp.google.com>
	 <49B9BF09.6010306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>, mrubin <mrubin@google.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:40435 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZCMDWg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Mar 2009 23:22:36 -0400
In-Reply-To: <49B9BF09.6010306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-03-12 at 21:03 -0500, Eric Sandeen wrote:
> Frank Mayhar wrote:
> > We're seeing errors like:
> >   EXT4-fs error (device sda3): ext4_mb_generate_buddy: EXT4-fs: group 3049: 21020 blocks in bitmap, 21529 in gd
> > 
> > Usually after this the system is cleaned and in the process we see many
> > "mb_free_blocks: double-free of inode x's block y(bit z in group d)".
> > (In fact, we see exactly as many of these as the difference between the
> > group and computed count of free blocks.)
> > 
> > It looks like the bitmap itself is getting messed up somehow, at least
> > enough to make the free count disagree with the map itself.  Has anyone
> > else seen something like this?  Any pointers as to where to look for
> > potential culprits?
> 
> Which kernel, for starters?

It's our development kernel, 2.6.26 plus as many of the ext4/jbd2
patches as we can comfortably pull in.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

