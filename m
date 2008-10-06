From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [PATCH] [RFC] jbd2: Add buffer triggers
Date: Mon, 6 Oct 2008 14:37:55 -0700
Message-ID: <20081006213754.GA26632@mail.oracle.com>
References: <20080917232629.GB20752@mail.oracle.com> <20080929012527.GI8711@mit.edu> <20081004000336.GE11442@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:19094 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYJFViQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 17:38:16 -0400
Content-Disposition: inline
In-Reply-To: <20081004000336.GE11442@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 03, 2008 at 08:03:36PM -0400, Theodore Tso wrote:
> I'm not sure you saw this e-mail, since I think it got in a mailman
> moderation queue.

	I've flagged you as "do not moderate".  I saw the email, but I
was in Prague for the cluster summit and didn't have time to look
in-depth.

> I've been looking more closely at this, and I think actually using
> this commit trigger gets very tricky.  Exactly how do you plan to use
> the commit trigger?  The caller is only going to be able to easily
> check the checksum on the frozen copy of the buffer; is that what you
> intended?  When and how do you plan set the checksum for a filesystem
> which is cleanly unmounted?  And are you planning on doing this for
> just the superblock, or for other data structures?  

	Every single metadata block in ocfs2 would have the commit
trigger set.  I intend to calculate the block checksums in the trigger.
That way I only compute the checksum once per journal write, rather than
every time I call journal_dirty_metadata().  That's my plan, at least.
	You may be right that my choice is too late and that I need to
trigger in an earlier place.  That's why I was taking time to reply: I
wanted to re-read the jbd2 source and be sure of what you were saying
and how I was handling it.  I haven't looked yet (just got back to the
office today), but here's what I understand so far.
	As far I could tell, actual writes of the buffer to the journal
go through journal_write_metadata_buffer().  Only in
journal_write_metadata_buffer() are you sure to have a frozen copy of
the buffer that won't be affected by parallel processes doing
journal_dirty_metadata().  Thus, the new_page and new_offset values are
set to b_data or b_frozen_data as needed.  When I get past that, I have
the right pointer.  I need to do it before the escape, of course,
because I want to checksum the block data, not the escaped data.
	Now, I'm sure this is the buffer that's going to the journal, I
think you're saying that this buffer may not be what gets checkpointed.
So the correct checksum hits the journal, but then an invalid one gets
to the real location on disk.  Is that right?  If so, I need to figure
out where to calculate the checksum somewhere higher, as you say.

Joel

-- 

"Nobody loves me,
 Nobody seems to care.
 Troubles and worries, people,
 You know I've had my share."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
