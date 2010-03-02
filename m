From: Nic Case <number9652@yahoo.com>
Subject: Re: [PATCH] mk2fs lazy_journal_init option
Date: Tue, 2 Mar 2010 11:36:21 -0800 (PST)
Message-ID: <78588.52120.qm@web43507.mail.sp1.yahoo.com>
References: <5B7315EF-A0AC-4C57-A0D4-DC0B071F87B8@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Shuichi Ihara <ihara@sun.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n62.bullet.mail.sp1.yahoo.com ([98.136.44.35]:35162 "HELO
	n62.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751779Ab0CBTgW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Mar 2010 14:36:22 -0500
In-Reply-To: <5B7315EF-A0AC-4C57-A0D4-DC0B071F87B8@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--- On Tue, 2/23/10, Andreas Dilger wrote:
> I haven't looked at this from a logic POV, but I tested
> this with a 1GB journal and it ran the same time
> with/without specifying "-O extents" (10s vs. 650s without
> this patch).  I also ran our additional e2fsck extents
> tests without errors, and on a couple of my extent-based
> filesystems.

Thanks for testing this patch, but after looking at it again,
it is clear it is not the right thing to do.  If there are at
least two levels of the extent tree with more than one entry,
iterating through with EXTENT_NEXT will return NO_EXTENT before
reaching the end of the file.  I sent another patch to the ext4
mailing list (with ext2fs_extent_get in the title) that I believe
is the right way to fix the problem.

Nic



      

