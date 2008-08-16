From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] ext4: flex_bg ialloc, don't pick "best_flex" with
 0 inodes
Date: Sat, 16 Aug 2008 12:35:18 -0500
Message-ID: <48A70FD6.80709@redhat.com>
References: <48A5FCA6.5070902@redhat.com> <20080816152541.GB8422@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"Jose R. Santos" <jrs@us.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36560 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbYHPST3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Aug 2008 14:19:29 -0400
In-Reply-To: <20080816152541.GB8422@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, Aug 15, 2008 at 05:01:10PM -0500, Eric Sandeen wrote:
>> It seems like adjusting the following test is a better plan;
>> for starters I do not see that best_flex can ever be < 0, so
> 
> Given that ext4_group_t is an unsigned long, that's certainly true.
> :-)

Heh, that too!

>> that test is replaced, and if the current "best" flex group
>> has no inodes free, and the current one does have room,
>> it is promoted to the next "best."
> 
> Looks good to me.  I've added it to the patch queue.
> 
>> Signed-of-by: Eric Sandeen <sandeen@redhat.com>
> 
> (forgot an 'f' :-)

Urk...

Thanks!

-Eric

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> 					- Ted

