From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext4:dev 47/50] fs/ext4/extents.c:4949 ext4_ext_punch_hole()
 warn: inconsistent returns mutex:&inode->i_mutex: locked (4813,4815)
 unlocked (4806,4949)
Date: Sun, 30 Sep 2012 23:20:25 -0400
Message-ID: <20121001032025.GB23264@thunk.org>
References: <20121001025047.GB12711@localhost>
 <87mx06vq3w.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	kernel-janitors@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53152 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab2JADU3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Sep 2012 23:20:29 -0400
Content-Disposition: inline
In-Reply-To: <87mx06vq3w.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 01, 2012 at 07:16:35AM +0400, Dmitry Monakhov wrote:
> On Mon, 1 Oct 2012 10:50:47 +0800, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Hi Dmitry,
> > 
> > FYI, there are new smatch warnings show up in
> > 
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> > head:   07043757c1a4018a04aded14deb1f28269a4b2ad
> > commit: c6a59106b4106d13dc824a388c5572ddd65a0779 [47/50] ext4: punch_hole should wait for DIO writers
> > 
> >   arch/x86/include/asm/jump_label.h:25 arch_static_branch() info: ignoring unreachable code.
> > + fs/ext4/extents.c:4949 ext4_ext_punch_hole() warn: inconsistent returns mutex:&inode->i_mutex: locked (4813,4815) unlocked (4806,4949)
> Yes, that is correct, my bad. Sorry, patch attached
> BTW  What tool(compile option) you use to catch this issue?

Fengguang is using Dan Carpenter's "smatch" tool.  For more
information, see:

	http://www.linuxplumbersconf.org/2011/ocw/sessions/165

						- Ted
