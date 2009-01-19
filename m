From: Theodore Tso <tytso@mit.edu>
Subject: Re: All processes accessing etx4 partition stuck in 'D' state
Date: Mon, 19 Jan 2009 07:43:05 -0500
Message-ID: <20090119124305.GB7598@mit.edu>
References: <87ljt7zt9q.fsf@newton.gmurray.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Graham Murray <graham@gmurray.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56117 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757469AbZASMnI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Jan 2009 07:43:08 -0500
Content-Disposition: inline
In-Reply-To: <87ljt7zt9q.fsf@newton.gmurray.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 19, 2009 at 06:47:45AM +0000, Graham Murray wrote:
> I do not know if this is ext4 related or not, so my apologies if it is
> not.
> 
> I am running the latest linus 2.6.29-rc2 git kernel together with the
> master branch of the ext4 git tree announced here a couple of days ago.
> 
> Yesterday evening, all processes accessing /home which is formatted as
> ext4 (created as ext4 under 2.6.26 with the ext4 patches applied, not
> converted from ext3) were stuck in 'D' state and top showed both cores
> of the core2 CPU in 100% Waiting state. Everything not accessing /home
> was responsive. To eliminate a physical problem I ran a SMART self-test
> on the drive containing /home and it passed with no errors. / is also
> etx4, but was converted from ext3. There were no kernel messages, just
> the hung processes. The system would not reboot normally (because of the
> processes in 'D' state), but following sysrq sync, mount r/o and reboot,
> the filesystem showed as clean when restarted. To be sure, the first
> thing I did was to unmount it and manually ran fsck -f and that did not
> report any problems. 

If this happens again, could you use sysrq-l and capture resulting the
stack backtraces?  That would help determine what parts of the kernel
are responsible.

Regards,

							- Ted
