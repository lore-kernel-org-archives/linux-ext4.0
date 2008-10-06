From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [PATCH] [RFC] jbd2: Add buffer triggers
Date: Mon, 6 Oct 2008 14:42:52 -0700
Message-ID: <20081006214251.GB26632@mail.oracle.com>
References: <20080917232629.GB20752@mail.oracle.com> <20080929012527.GI8711@mit.edu> <20081004000336.GE11442@mit.edu> <20081006213754.GA26632@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:23127 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbYJFVnu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 17:43:50 -0400
Content-Disposition: inline
In-Reply-To: <20081006213754.GA26632@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2008 at 02:37:54PM -0700, Joel Becker wrote:
> On Fri, Oct 03, 2008 at 08:03:36PM -0400, Theodore Tso wrote:
> 	Now, I'm sure this is the buffer that's going to the journal, I
> think you're saying that this buffer may not be what gets checkpointed.
> So the correct checksum hits the journal, but then an invalid one gets
> to the real location on disk.  Is that right?  If so, I need to figure
> out where to calculate the checksum somewhere higher, as you say.

	Ok, looking at your first email again, you're saying to move up
to the "Check for escaping" section.  There we might checksum b_data
before it's copied out.  This is, indeed, safe against the problem you
mentioned.  I also think it's safe to checksum b_frozen_data if already
set there, as that's a frozen for commit buffer.  Can I trust that
checksumming b_data there will not be overwritten by another process
doing journal_dirty_metadata() before we write out our buffer?  Can I
trust that the b_frozen_data, if already copied, will be the buffer
committed and checkpointed?  If so, I think that change works.

Joel

-- 

"What no boss of a programmer can ever understand is that a programmer
 is working when he's staring out of the window"
	- With apologies to Burton Rascoe

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
