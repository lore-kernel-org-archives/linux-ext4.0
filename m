From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [PATCH 4/4] jbd2: don't dirty original metadata buffer on abort
Date: Mon, 13 Oct 2008 13:36:42 -0700
Message-ID: <20081013203641.GA6469@mail.oracle.com>
References: <48EF168A.4000705@hitachi.com> <48EF1A11.9090303@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	jack@suse.cz
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:60130 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbYJMUiA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2008 16:38:00 -0400
Content-Disposition: inline
In-Reply-To: <48EF1A11.9090303@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 10, 2008 at 06:02:09PM +0900, Hidehiro Kawai wrote:
> Currently, original metadata buffers are dirtied when they are
> unfiled whether the journal has aborted or not.  Eventually these
> buffers will be written-back to the filesystem by pdflush.  This
> means some metadata buffers are written to the filesystem without
> journaling if the journal aborts.  So if both journal abort and
> system crash happen at the same time, the filesystem would become
> inconsistent state.  Additionally, replaying journaled metadata
> can overwrite the latest metadata on the filesystem partly.
> Because, if the journal gets aborted, journaled metadata are
> preserved and replayed during the next mount not to lose
> uncheckpointed metadata.  This would also break the consistency
> of the filesystem.
> 
> This patch prevents original metadata buffers from being dirtied
> on abort by clearing BH_JBDDirty flag from those buffers.  Thus,
> no metadata buffers are written to the filesystem without journaling.

	It's not my place to Ack such patches, but I noticed this bug
during Plumbers, and Eric and Andreas pointed me to this patch, which
fixes it quite nicely.  Just $0.02 :-)

Joel

-- 

Life's Little Instruction Book #94

	"Make it a habit to do nice things for people who 
	 will never find out."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
