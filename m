From: Andreas Dilger <adilger@sun.com>
Subject: Re: Same magic in statfs() call for ext?
Date: Mon, 30 Mar 2009 12:23:28 -0600
Message-ID: <20090330182328.GA3199@webber.adilger.int>
References: <20090316133615.GA10596@duck.suse.cz> <49BE7A99.5050601@redhat.com>
 <20090316162737.GC10596@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41209 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478AbZC3SYG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Mar 2009 14:24:06 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n2UINmaP021313
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 11:24:03 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KHB00J00YXECS00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 30 Mar 2009 11:23:48 -0700 (PDT)
In-reply-to: <20090316162737.GC10596@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 16, 2009  17:27 +0100, Jan Kara wrote:
> On Mon 16-03-09 11:13:13, Eric Sandeen wrote:
> > But off the top of my head, I think that I would prefer to see
> > applications generally do the right, posix-conformant thing w.r.t. data
> > integrity (i.e. fsync()) unless, via statfs, they find out "fsync hurts,
> > and we're likely to be reasoonably safe without it"
> > 
> > IOW, adding exceptions for ext3 sounds better to me than munging ext4,
> > xfs, btrfs, and all future filesystems to conform to some behavior which
> > isn't in any API or spec ...
>
>   Yes, I agree that if they want data on disk, they should use fsync(). But
> as you say for ext3 this is not really usable so they have to somehow
> recognize that "they are on a filesystem where fsync() sucks" and avoid it
> as much as possible. And I feel slightly in favor of giving them enough rope
> (i.e., different magic numbers in statfs) to hang themselves ;-).

One possibility that I've thought of in the past is to have "dynamic
data=journal" mode when fsync is being called and files are small.
What this means is that small file data will be written to the journal
on fsync instead of journaling only the metadata and flushing the data
to the filesystem in ordered mode.

While it means data is written twice to disk (once to journal, once to
fs), if there is a lot of fsync going on and the files are small then
it may still be faster than doing the seeks.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

