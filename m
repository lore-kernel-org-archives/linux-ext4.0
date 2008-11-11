From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext3 aborts journal
Date: Tue, 11 Nov 2008 09:52:43 -0500
Message-ID: <20081111145243.GB13960@mit.edu>
References: <20081110075704.GA31730@gamma.logic.tuwien.ac.at> <49185AEB.5070302@redhat.com> <20081111094346.GR21495@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Norbert Preining <preining@logic.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:54514 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755581AbYKKOxJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Nov 2008 09:53:09 -0500
Content-Disposition: inline
In-Reply-To: <20081111094346.GR21495@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 11, 2008 at 10:43:46AM +0100, Norbert Preining wrote:
> Dear Eric,
> 
> On Mo, 10 Nov 2008, Eric Sandeen wrote:
> > I believe this was fixed by:
> 
> thanks, that seems to be in rc4, at least patch did not apply, but the
> code in checkpoint.c looks suspiciously like a variant of this patch has
> already been applied.

Correct, the fix is in -rc4.

Regards,

						- Ted
