From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data	buffers
Date: Wed, 04 Jun 2008 15:58:34 -0600
Message-ID: <20080604215834.GA2961@webber.adilger.int>
References: <4843CE15.6080506@hitachi.com> <4843CEED.9080002@hitachi.com>
 <20080603153050.fb99ac8a.akpm@linux-foundation.org>
 <20080604101925.GB16572@duck.suse.cz>
 <20080604111911.c1fe09c6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, sct@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36162 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbYFDV6q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 17:58:46 -0400
In-reply-to: <20080604111911.c1fe09c6.akpm@linux-foundation.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 04, 2008  11:19 -0700, Andrew Morton wrote:
> On Wed, 4 Jun 2008 12:19:25 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> > On Tue 03-06-08 15:30:50, Andrew Morton wrote:
> > > On Mon, 02 Jun 2008 19:43:57 +0900
> > > Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:
> > > 
> > > > 
> > > > In ordered mode, we should abort journaling when an I/O error has
> > > > occurred on a file data buffer in the committing transaction.
> > > 
> > > Why should we do that?
> >   I see two reasons:
> > 1) If fs below us is returning IO errors, we don't really know how severe
> > it is so it's safest to stop accepting writes. Also user notices the
> > problem early this way. I agree that with the growing size of disks and
> > thus probability of seeing IO error, we should probably think of something
> > cleverer than this but aborting seems better than just doing nothing.
> > 
> > 2) If the IO error is just transient (i.e., link to NAS is disconnected for
> > a while), we would silently break ordering mode guarantees (user could be
> > able to see old / uninitialized data).
> > 
> 
> Does any other filesystem driver turn the fs read-only on the first
> write-IO-error?
> 
> It seems like a big policy change to me.  For a lot of applications
> it's effectively a complete outage and people might get a bit upset if
> this happens on the first blip from their NAS.

I agree with Andrew.  The historical policy of ext2/3/4 is that write
errors for FILE DATA propagate to the application via EIO, regardless
of whether ordered mode is active or not.  If filesystem METADATA is
involved, yes this should cause an ext3_error() to be called and the
policy for what to do next is controlled by the administrator.

If the journal is aborted for a file data write error, the node maybe
panics (errors=panic) or is rebooted by the administrator, then e2fsck
is run and no problem is found (which it will not because e2fsck does
not check file data), then all that has been accomplished is to reboot
the node.

Applications should check the error return codes from their writes,
and call fsync on the file before closing it if they are really worried
about whether the data made it to disk safely, otherwise even a read-only
filesystem will not cause the application to notice anything.

Now, if we have a problem where the write error from the journal checkpoint
is not being propagated back to the original buffer, that is a different
issue.  For ordered-mode data I don't _think_ that the data buffers are
mirrored when a transaction is closed, so as long as the !buffer_uptodate()
error is propagated back to the caller on fsync() that is enough.

We might also consider having a separate mechanism to handle write failures,
but I don't think that that should be intermixed with the ext3 error handling
for metadata errors.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

