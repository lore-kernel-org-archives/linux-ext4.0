From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync performance when
 using CFQ
Date: Tue, 22 Jun 2010 15:13:07 -0700
Message-ID: <20100622221306.GA20090@mail.oracle.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:20148 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab0FVWOv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jun 2010 18:14:51 -0400
Content-Disposition: inline
In-Reply-To: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 22, 2010 at 05:34:59PM -0400, Jeff Moyer wrote:
> Running iozone with the fsync flag, or fs_mark, the performance of CFQ is
> far worse than that of deadline for enterprise class storage when dealing
> with file sizes of 8MB or less.  I used the following command line as a
> representative test case:
> 
>   fs_mark -S 1 -D 10000 -N 100000 -d /mnt/test/fs_mark -s 65536 -t 1 -w 4096 -F

	I'd be interested in how ocfs2 does, because we use jbd2 too.

Joel

-- 

Life's Little Instruction Book #139

	"Never deprive someone of hope; it might be all they have."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
