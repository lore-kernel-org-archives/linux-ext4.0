From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] imporve jbd2 fsync batching
Date: Wed, 5 Nov 2008 19:27:27 -0500
Message-ID: <20081106002727.GB8168@mit.edu>
References: <20081104161024.GC28058@unused.rdu.redhat.com> <20081105231012.GJ3184@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54520 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752044AbYKFA1a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 19:27:30 -0500
Content-Disposition: inline
In-Reply-To: <20081105231012.GJ3184@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 05, 2008 at 04:10:12PM -0700, Andreas Dilger wrote:
> There was no reply to my previous comments about making the maximum sleep
> time be a fixed value (e.g. 15ms) instead of having it arbitrarily based
> on the jiffies value, which may change between 1ms and 10ms.

I know the whole point is to make it be self-tuning, but I wonder if
we should have some knobs to control the min and max sleep times.

   	          	       	    	     	     - Ted
