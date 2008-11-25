From: Theodore Tso <tytso@mit.edu>
Subject: Re: rm: cannot remove `???': No such file or directory
Date: Tue, 25 Nov 2008 15:28:41 -0500
Message-ID: <20081125202841.GF525@mit.edu>
References: <492AB6C5.1050609@cerberis.soften.ktu.lt> <20081125063558.GG20928@mit.edu> <492BCA76.50308@cerberis.soften.ktu.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Arturas K <arturas@cerberis.soften.ktu.lt>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:49954 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751550AbYKYU2o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 15:28:44 -0500
Content-Disposition: inline
In-Reply-To: <492BCA76.50308@cerberis.soften.ktu.lt>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 25, 2008 at 11:50:46AM +0200, Arturas K wrote:
> as I written before:

Sorry I missed that before.  Yeah, known problem, fixed in git commit
3c37fc86 in the 2.6.28-rc development cycle.  The patch has been
queued to the stable kernel maintainers for inclusion in an upcoming
2.6.27.y release, but it hasn't made it out yet.  I can file a request
to include a set of patches into a future Ubuntu kernel update, but I
don't know how quickly Ubuntu will push out a new kernel.

      	       	       	      	   	    - Ted
