From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add project quota mount options
Date: Fri, 8 Jul 2016 00:48:21 -0400
Message-ID: <20160708044821.GG19871@thunk.org>
References: <1467875386-28092-1-git-send-email-wangshilong1991@gmail.com>
 <b7ac32ea-b70d-0dc1-4b3e-f4f47dbad737@redhat.com>
 <20160708031002.GF19871@thunk.org>
 <CAP9B-Qm_fuw3rNGyc4068YADbOisjVm=35=siChgks4=v62qtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
	Wang Shilong <wshilong@ddn.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41410 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbcGHEs1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jul 2016 00:48:27 -0400
Content-Disposition: inline
In-Reply-To: <CAP9B-Qm_fuw3rNGyc4068YADbOisjVm=35=siChgks4=v62qtw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 08, 2016 at 12:36:56PM +0900, Wang Shilong wrote:
> 
> I do agree with your point here, but the problem is as you can see come
> from xfstests arguments from Dave Chinner.
> 
> I don't think currently users will try to old interface with project quota.
> But as your request, i think you need some tests for project quota...

I think we need some real clarity about exactly what Dave is asking
for.  I think what Eric and Dave have been asking for is testing both
of these two different quota management stacks:

(1) XFS has ioctl's which come from the Irix days, and these are used by
the xfs quota utilities.

(2) Quotatools uses the quotactl(2) system call, and so there is an
entirely **different** code path which we can exercise.

This is a completely orthogonal question from which mount options and
which mkfs options are used to set up project quota support for ext4.
That's an ext4-specific concern, and I don't see why Dave would have
any interest in what ext4 chooses to support here.

						- Ted
