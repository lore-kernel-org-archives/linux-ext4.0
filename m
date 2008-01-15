From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm
	patch]
Date: Tue, 15 Jan 2008 10:28:01 -0500
Message-ID: <20080115152801.GA7292@mit.edu>
References: <200801140839.01986.abhishekrai@google.com> <20080114163412.83a8b18d.akpm@linux-foundation.org> <20080115030441.a0270609.akpm@linux-foundation.org> <20080115131533.GA5766@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Abhishek Rai <abhishekrai@google.com>,
	linux-kernel@vger.kernel.org, rohitseth@google.com,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752857AbYAOP2j@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080115131533.GA5766@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 15, 2008 at 01:15:33PM +0000, Christoph Hellwig wrote:
> They won't fsck in planned downtimes.  They will have to use fsck when
> the shit hits the fan and they need to.   Not sure about ext3, but big
> XFS user with a close tie to the US goverment were concerned about this
> case for really big filesystems and have sponsored speedup including
> multithreading xfs_repair.  I'm pretty sure the same arguments apply
> to ext3, even if the filesystems are a few magnitudes smaller.

Agreed, 100%.  Even if you fsck snapshots during slow periods, it
still doesn't help you if the filesystem gets corrupted due to a
hardware or software error.  That's where this will matter the most.

Val Hensen has done a proof of concept patch that multi-threads e2fsck
(and she's working on one that would be long-term supportable) that
might reduce the value of this patch, but metaclustering should still
help.

> > In any decent environment, people will fsck their ext3 filesystems during
> > planned downtime, and the benefit of reducing that downtime from 6
> > hours/machine to 2 hours/machine is probably fairly small, given that there
> > is no service interruption.  (The same applies to desktops and laptops).
> > 
> > Sure, the benefit is not *zero*, but it's small.  Much less than it would
> > be with ext2.  I mean, the "avoid unplanned fscks" feature is the whole
> > reason why ext3 has journalling (and boy is that feature expensive during
> > normal operation).

Also, it's not just reducing fsck times, although that's the main one.
The last time this was suggested, the rationale was to speed up the
"rm dvd.iso" case.  Also, something which *could* be done, if Abhishek
wants to pursue it, would be to pull in all of the indirect blocks
when the file is opened, and create an in-memory extent tree that
would speed up access to the file.  It's rarely worth doing this
without metaclustering, since it doesn't help for sequential I/O, only
random I/O, but with metaclustering it would also be a win for
sequential I/O.  (This would also remove the minor performance
degradation for sequential I/O imposed by metaclustering, and in fact
improve it slightly for really big files.)

					- Ted
