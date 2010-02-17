From: tytso@mit.edu
Subject: Re: [RFC] do you want jbd2 interface of ext3?
Date: Wed, 17 Feb 2010 11:49:33 -0500
Message-ID: <20100217164933.GC5337@thunk.org>
References: <20100216164123.b10b00e5.toshi.okajima@jp.fujitsu.com>
 <20100216185452.GE3153@quack.suse.cz>
 <4B7BAA70.9070605@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	adilger@sun.com, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48851 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab0BQQtp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Feb 2010 11:49:45 -0500
Content-Disposition: inline
In-Reply-To: <4B7BAA70.9070605@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 17, 2010 at 05:36:00PM +0900, Toshiyuki Okajima wrote:
> 
> The reason that I wanted to change the journaling interface into jbd2 were:
> - the most of my customers use linux for Mission Critical (M.C.).
> - M.C. users want the filesystems which have more integrity for their data.
> - I think we should not recommend ext4 to M.C. users because
>   for M.C. users, ext4 is still unstable filesystem.
>   Therefore I want to let M.C. users use ext3 for the present.
> - it is not easy to maintain both jbd and jbd2, so
>   I thought it was easy to solve it by unifying the journaling interfaces
>   into ext4.

But if they are mission critical users, why would they be willing to
accept changes to the jbd2 layer, and the necessary changes to ext3 so
it can use jbd2?  Any time you add changes, you will be causing a
certain amount of instability and risk.  So the question is, what are
your users willing to tolerate?

Some important questions to ask:

1) Is the problem psychological?  i.e., is the problem that it is
*called* ext4?  After all, ext4 is derived from ext3, so if they are
willing to accept new features backported into ext3 (i.e., journal
checksums) and the risks associated with making changes to add new
features, why are they not willing to accept ext4?

2) If it is a question of risk, how many changes are they willing to
accept?  I will note that if you don't enable extents, and disable
delayed allocation, you can significantly decrease the risk of using
ext4.  (Essentially at that point the only major change is the block
allocation code and the changes to use jbd2.)

3) How much testing do you need to do before it would be considered
acceptable for your Mission Critical users?  Or is it a matter of time
to allow other users to be the "guinea pigs"?  :-)

> OK. I see.
> (ext3 is already stable filesystem, so, we should not change
>  ext3 drastically.)

Well, certainly, *any* change is going to risk destablizing the file
system.  Isn't that the argument why you are concerned about whether
ext4 is ready for your M.C. users?  One of the reasons why we forked
jbd2 from jbd was precisely because of these sorts of concerned.  So
if you switch ext3 to use jbd2, would that not increase the risk to
your M.C. users?

Best regards,

      		       	      	  	    - Ted
