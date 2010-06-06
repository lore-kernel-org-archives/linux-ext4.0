From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: ext4 2.6.35-rc2 regression (ext4: Make sure the MOVE_EXT ioctl
 can't overwrite append-only files)
Date: Sun, 6 Jun 2010 19:23:39 +0200
Message-ID: <20100606172339.GA1778@arch.tripp.de>
References: <20100606081601.GA1807@arch.tripp.de>
 <DB34C7CA-53EC-47B0-AD31-4C729B983C11@mit.edu>
 <20100606115947.GA1783@arch.tripp.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-195.synserver.de ([212.40.180.195]:1050 "HELO
	smtp-out-195.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756618Ab0FFRXl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Jun 2010 13:23:41 -0400
Content-Disposition: inline
In-Reply-To: <20100606115947.GA1783@arch.tripp.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 06, 2010 at 01:59:47PM +0200, Markus Trippelsdorf wrote:
> On Sun, Jun 06, 2010 at 07:45:48AM -0400, Theodore Tso wrote:
> > 
> > On Jun 6, 2010, at 4:16 AM, Markus Trippelsdorf wrote:
> > 
> > > Commit 1f5a81e41f8b1a782c68d3843e9ec1bfaadf7d72
> > > "ext4: Make sure the MOVE_EXT ioctl can't overwrite append-only files"
> > > causes the following kernel BUG on my machine (x86_64):
> > > 
> > > BUG: Bad page map in process mpd  pte:720072000000000 pmd:11d2f7067
> > > addr:00007f6b09f82000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:132
> > > vma->vm_ops->fault: filemap_fault+0x0/0x31e
> > > vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
> > > Pid: 1672, comm: mpd Not tainted 2.6.35-rc2-00032-g78a5aa2 #45
> > > Call Trace:
> > > [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
> > > [<ffffffff810b8c9b>] unmap_vmas+0x50c/0x803
> > > [<ffffffff810be003>] exit_mmap+0xc4/0x14a
> > > [<ffffffff81057bc6>] mmput+0x2d/0xb9
> > 
> > What makes you think it was the commit you cited that is causing this crash?  Unless you are specifically using e2defrag (or write code which explicitly calls this ext4-specific ioctl), the code path in question wouldn't even be entered, and I see nothing in this stack trace to indicate it was caused by this change.
> > 
> > (And in fact in a subsequent e-mail I see that you've tried reverting both changes to ext4 between rc1 and rc2 and it didn't seem to help.)
> > 
> > Have you tried bisecting the kernel to find commit which introduced this problem?   What was the last kernel that didn't have these problem for you?  -rc1?   How easy is this to reproduce?   Does this happen as soon as you boot up your system?
> > 
> I did a git pull this morning and hit the problem after rebooting. I
> then looked in the changelog for recent ext4 commits and found the two
> entries. I reverted the first one and the problem was still there. 
> Then I reverted the second one and the problem went away. After that I
> reverted my last revert and the problem reappeared...
> 
> (From that I concluded that 1f5a81e41f8b1a782c68d3843e9ec1bfaadf7d72 was
> the root of the problem. But maybe it was just a strange coincident)
> 
> I haven't tried a full bisection yet. The last working kernel was just
> the git kernel from about 5 days ago. The bug is quiet easy to reproduce
> and usually happens right after I boot my system and sometimes when I
> shut it down.
> 
> I will try a bisection later today.

Since this bug is not deterministically reproducible bisecting turned out
harder then anticipated. I get as far as:
bad d2dd328b7f7bc6cebe167648289337755944ad2a
good a094c0afc3515aaf962dd0793f3b23fe67e6b192
(Take even this result with a grain of salt, because a single wrong "git
bisect good" will lead to wrong results)

After that git bisect quickly goes to lala land. 
-- 
Markus
