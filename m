From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 4/4] jbd2: don't dirty original metadata buffer on abort
Date: Mon, 13 Oct 2008 22:58:14 -0400
Message-ID: <20081014025814.GB9332@mit.edu>
References: <48EF168A.4000705@hitachi.com> <48EF1A11.9090303@hitachi.com> <20081013203641.GA6469@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, adilger@sun.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44033 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755262AbYJNC6U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2008 22:58:20 -0400
Content-Disposition: inline
In-Reply-To: <20081013203641.GA6469@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 13, 2008 at 01:36:42PM -0700, Joel Becker wrote:
> > This patch prevents original metadata buffers from being dirtied
> > on abort by clearing BH_JBDDirty flag from those buffers.  Thus,
> > no metadata buffers are written to the filesystem without journaling.
> 
> 	It's not my place to Ack such patches, but I noticed this bug
> during Plumbers, and Eric and Andreas pointed me to this patch, which
> fixes it quite nicely.  Just $0.02 :-)

Already pushed to Linus, and in mainline.  :-)

							- Ted
