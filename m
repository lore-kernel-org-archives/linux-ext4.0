From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from
 previous mount: IO failure
Date: Fri, 22 Oct 2010 13:25:36 -0400
Message-ID: <20101022172536.GP3127@thunk.org>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Bernd Schubert <bschubert@ddn.com>
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51623 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab0JVRZl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 13:25:41 -0400
Content-Disposition: inline
In-Reply-To: <201010221533.29194.bs_lists@aakef.fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 22, 2010 at 03:33:29PM +0200, Bernd Schubert wrote:
> 
> is is really a good idea to allow the filesystem to mount if something like
> that comes up? I really would prefer if mount would abort.
> 
> Oct 22 12:37:36 vm7 kernel: [ 1227.814294] LDISKFS-fs warning (device sfa0074): ldiskfs_clear_journal_err: Filesystem error recorded from p
> revious mount: IO failure
> Oct 22 12:37:36 vm7 kernel: [ 1227.814314] LDISKFS-fs warning (device sfa0074): ldiskfs_clear_journal_err: Marking fs in need of filesystem
>  check.
> 
> (please ignore "ldiskfs", it was just renamed to that by Lustre, but is 
> ext4 based as in RHEL5.5, so 2.6.32-ish).

Did you try running e2fsck first?  If it detects the error after
running the journal, it will run the file system check right then and
there.  If it doesn't, it's a bug.  If you're not running e2fsck
first, and the filesystem had previously detected inconsistencies, the
long-standing tradition is to allow that, since root should know what
it's doing.

And there are times when you do want to mount a filesystem with known
errors; for example, in the case of the root file system, we have
always allowed a read-only mount to continue, so that we can run
e2fsck without requiring a rescue CD 99% of the time.

	  	   	     	     - Ted
