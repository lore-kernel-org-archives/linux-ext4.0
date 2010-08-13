From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ext3/ext4: Factor out disk
 addressability check
Date: Thu, 12 Aug 2010 23:39:18 -0400
Message-ID: <20100813033918.GF2763@thunk.org>
References: <874ofr2myq.fsf@patl.com>
 <20100812174215.GC6561@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org Patrick J. LoPresti"
	<lopresti@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56803 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab0HMDjZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Aug 2010 23:39:25 -0400
Content-Disposition: inline
In-Reply-To: <20100812174215.GC6561@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 12, 2010 at 10:42:16AM -0700, Joel Becker wrote:
> On Thu, Jul 22, 2010 at 03:03:41PM -0700, Patrick J. LoPresti wrote:
> > As part of adding support for OCFS2 to mount huge volumes, we need to
> > check that the sector_t and page cache of the system are capable of
> > addressing the entire volume.
> > 
> > An identical check already appears in ext3 and ext4.  This patch moves
> > the addressability check into its own function in fs/libfs.c and
> > modifies ext3 and ext4 to invoke it.
> > 
> > Signed-off-by: Patrick LoPresti <lopresti@gmail.com>
> 
> Dear ext3/4 folks,
> 	I've pushed this patch to the merge-window branch of ocfs2.git.
> I'm ready to send it to Linus, But I need your OK.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

for the ext4 bits.

(Sorry for not responding earlier to some of these patches.  The fact
that the merge window overlapped with LinuxCon and the Linux
Storage/Filesystem workshop has been quite stressful/tiring for some
of us....)

					- Ted
