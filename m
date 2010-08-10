From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ext3/ext4: Factor out disk
 addressability check
Date: Tue, 10 Aug 2010 08:15:19 -0700
Message-ID: <20100810151518.GC3025@mail.oracle.com>
References: <874ofr2myq.fsf@patl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:41565 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab0HJPQa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Aug 2010 11:16:30 -0400
Content-Disposition: inline
In-Reply-To: <874ofr2myq.fsf@patl.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 22, 2010 at 03:03:41PM -0700, Patrick J. LoPresti wrote:
> As part of adding support for OCFS2 to mount huge volumes, we need to
> check that the sector_t and page cache of the system are capable of
> addressing the entire volume.
> 
> An identical check already appears in ext3 and ext4.  This patch moves
> the addressability check into its own function in fs/libfs.c and
> modifies ext3 and ext4 to invoke it.
> 
> Signed-off-by: Patrick LoPresti <lopresti@gmail.com>

ext4/jbd2 folks,
	I would like to push these upstream.  Should they go through
ocfs2.git or would you rather take them via your trees?

Joel

-- 

"In the arms of the angel, fly away from here,
 From this dark, cold hotel room and the endlessness that you fear.
 You are pulled from the wreckage of your silent reverie.
 In the arms of the angel, may you find some comfort here."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
