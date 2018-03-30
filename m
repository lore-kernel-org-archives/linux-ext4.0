From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: linux-next 20180327 - "SELinux: (dev dm-3, type ext4) getxattr
 errno 34"
Date: Thu, 29 Mar 2018 21:32:21 -0400
Message-ID: <20180330013221.GD3790@thunk.org>
References: <24018.1522346273@turing-police.cc.vt.edu>
 <db97ea5d-0925-63bd-6840-1364a7977a50@tycho.nsa.gov>
 <026f2dc7-1c9c-93ff-569c-87a77aad0ece@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: valdis.kletnieks@vt.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
To: Stephen Smalley <sds@tycho.nsa.gov>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <026f2dc7-1c9c-93ff-569c-87a77aad0ece@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 29, 2018 at 02:35:44PM -0400, Stephen Smalley wrote:
> > 
> > broke a longstanding assumption by SELinux that it could call getxattr with a NULL buffer and 0 size to probe whether the filesystem supports the security xattrs at mount time.
> > 
> > Options for fixing:
> > - Revert or revise that patch to not return -ERANGE if buffer is NULL (prior behavior),
> > - Change SELinux sb_finish_set_opts() to treat -ERANGE as a non-error result.
> 
> Per https://bugzilla.kernel.org/show_bug.cgi?id=199185#c4, other callers besides SELinux are also broken by this change, so a revert or revision of the ext4 commit seems necessary regardless.

Yes, the breakage is my fault; my apologies.  The new version of the
patch is already posted in bugzilla (and on linux-ext4).  I'll be
pushing out a refreshed ext4.git branch shortly.

					- Ted
