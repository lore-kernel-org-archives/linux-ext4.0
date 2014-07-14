From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: RE: [PATCH 2/3] xfs: Add support IOC_MOV_DATA ioctl
Date: Mon, 14 Jul 2014 20:27:26 +0400
Message-ID: <87ha2jsy6p.fsf@openvz.org>
References: <003f01cf9aa4$1e9e5240$5bdaf6c0$@samsung.com> <20140708121500.GA518@infradead.org> <001801cf9b3f$ad786ff0$08694fd0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Dave Chinner' <david@fromorbit.com>,
	'Theodore Ts'o' <tytso@mit.edu>,
	'linux-ext4' <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	'Luk?? Czerner' <lczerner@redhat.com>,
	'Brian Foster' <bfoster@redhat.com>,
	'Ashish Sangwan' <a.sangwan@samsung.com>, xfs@oss.sgi.com
To: Namjae Jeon <namjae.jeon@samsung.com>,
	'Christoph Hellwig' <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:58878 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbaGNQ1a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2014 12:27:30 -0400
In-Reply-To: <001801cf9b3f$ad786ff0$08694fd0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 09 Jul 2014 15:33:21 +0900, Namjae Jeon <namjae.jeon@samsung.com> wrote:
> > 
> > On Tue, Jul 08, 2014 at 08:59:49PM +0900, Namjae Jeon wrote:
> > > This patch implements fs ioctl's IOC_MOV_DATA for XFS.
> > 
> > Shouldn't this share code with the XFS_IOC_SWAPEXT implementation?
> Lukas has raised the same question for ext4.
> Both xfs(XFS_IOC_SWAPEXT) and ext4(EXT4_IOC_MOVE_EXT) has ioctls which uses
> almost similar kind of structure as struct mov_data.
> As such, there seems to be possiblity for sharing basic code (I will try)
> used for sanity checking in IOC_MOV_DATA to be shared with these ioctls
> but the core functionality code will remain different.
> 
> Thanks!
Actually they are differ. EXT4_IOC_MOVE_EXT copy data inside kernel,
but XFS_IOC_SWAPEXT live this job to userpsace see:
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=blob;f=fsr/xfs_fsr.c packfile
And I'll vote to make EXT4_IOC_MOVE_EXT deprecated, and implement EXT4_IOC_SWAPEXT
as XFS does that.
Ted, Lukas what do you think about that?

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
