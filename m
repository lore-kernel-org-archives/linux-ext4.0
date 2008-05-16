From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Fri, 16 May 2008 23:09:06 +0100
Message-ID: <20080516220906.GC15334@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516135814.1c973bd5.akpm@linux-foundation.org> <20080516214516.GA15334@shareable.org> <482E049A.5020005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:50152 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYEPWJO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 May 2008 18:09:14 -0400
Content-Disposition: inline
In-Reply-To: <482E049A.5020005@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> so only non-default is shown, so today barrier=0 is not shown.  I
> suppose that could be changed...

Yes, I suggest that, even if barrier=0 remains the default.  I suggest
showing barrier=1 no matter what the default, too, since if the
default is changed, no option will become ambiguous in bug reports,
cut and pastes etc.

> FWIW, my patch would show barrier=0 if it's manually mounted that way
> (against new proposed defaults), or if we are running w/o barriers due
> to a failed barrier IO even though barriers were requested.

Speaking of failed barrier I/O, it should be possible to fall back to
"disable cache, write commit block, enable cache" on old drives which
don't have the cache flush command.

> > On a related note, there is advice floating about the net to run with
> > IDE write cache turned off if you're running a database and care about
> > integrity.  That has much worse performance than barriers.
> 
> ... and I've seen hand-waving about shortened drive life running this
> way?  but who really knows....

I've no idea.  It makes sense: disabling write cache increases the
number of seeks for many loads.

In any case, with barriers implemented properly you get basically the
same level of integrity as disabling the write cache, without the
substantial performance hit.

-- Jamie
