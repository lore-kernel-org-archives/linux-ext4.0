From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4-fs error in ext4_reserve_inode_write: Journal has aborted
Date: Fri, 22 May 2009 07:10:39 -0400
Message-ID: <20090522111039.GB11742@mit.edu>
References: <40101cc30905201635t6af2586bne1acbc77216628ee@mail.gmail.com> <4A14AC12.4000108@redhat.com> <40101cc30905220131t48d3de40y89beafb15d9e2201@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Matteo Croce <matteo@openwrt.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52806 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbZEVLLA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 May 2009 07:11:00 -0400
Content-Disposition: inline
In-Reply-To: <40101cc30905220131t48d3de40y89beafb15d9e2201@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 22, 2009 at 10:31:17AM +0200, Matteo Croce wrote:
> the HD seems to reset soon.
> can it be an hardware problem?

I'm not sure what you mean by "the HD seems to reset soon"?

If there was a "Journal has aborted" error, there must have been some
some other ext4 or jbd2 reported problem earlier in the log that
caused the journal to have aborted.  Could you search your log file
for anything beforehand mentioning "ext4", "EXT4-fs", or "jbd2", or
"journal"?

Thanks,

    	     			   	   	      	 - Ted

