Return-Path: <SRS0=WpiV=MV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54284 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbeJIJhW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Oct 2018 05:37:22 -0400
Date: Mon, 8 Oct 2018 22:22:43 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: valdis.kletnieks@vt.edu
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [BUG] ext4 null pointer crash in linux-next
Message-ID: <20181009022243.GD3369@thunk.org>
References: <36243.1539028475@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36243.1539028475@turing-police.cc.vt.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 08, 2018 at 03:54:35PM -0400, valdis.kletnieks@vt.edu wrote:
> I'm seeing a fairly replicable crash/hang with a traceback implicating ext4 (or
> possibly the block layer). next-20180918 seemed stable, but next-20180926 and
> -next-20181005 have a habit of crashing while dnf is updating software (so far,
> I've hit it 6 times with identical tracebacks while attempting to update software
> 
> This ringing any bells, or did I just buy myself another git bisect? Google says
> that ext4_mpage_readpages from the traceback hasn't been referenced in the
> last 2 months...

I'm afraid you're going to have to do a git bisect.  I've been doing
full regression tests of ext4.git and nothing like this has turned up.

Instead of doing a full bisect, maybe try doing the ext4.git tree by
itself, and the block.git tree by itself, and maybe those two trees
merged together?

						- Ted
