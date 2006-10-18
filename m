From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH/RFC] - make ext3 more robust in the face of filesystem
 corruption
Date: Wed, 18 Oct 2006 16:56:47 -0500
Message-ID: <4536A31F.5050604@redhat.com>
References: <45369869.60400@redhat.com> <20061018214022.GJ3509@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:26084 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1423039AbWJRV4v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 17:56:51 -0400
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20061018214022.GJ3509@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Oct 18, 2006  16:11 -0500, Eric Sandeen wrote:
>> First, we had a corrupted index directory that was never checked
>> for consistency... it was corrupt, and pointed to another "entry"
>> of length 0.  The for() loop looped forever, since the length
>> of ext3_next_entry(de) was 0, and we kept looking at the same
>> pointer over and over and over and over... I modeled this check
>> and subsequent action on what is done for non-index directories
>> in ext3_readdir... but I also see a few places where this check
>> is deemed "too expensive" - any thoughts?
> 
> Hmm, in 2.6 ext2 this is handled somewhat differently - one of the main
> places where ext2 and ext3 differ.  The directory leaf data is kept in
> the page cache and there is a helper function ext2_check_page() to mark
> the page "checked".  That means the page only needs to be checked once
> after being read from disk, instead of each time through readdir.

ah, sure.  Hm...  well, this might be a bit of a performance hit if it's
checking cached data... let me think on that.

<... next patch ...>

> I'm not sure whether this is a win or not.  It means that if there is ever
> a directory with a bad leaf block any entries beyond that block are not
> accessible anymore.  

I'm amazed at how hard ext3 works to cope with bad blocks ;-)

Hm, yes, so just bailing out may not be so good.

> The existing !bh case already marks the filesystem in
> error.  Maybe as a special case we can check in "if (!bh)" if i_size and
> i_blocks make sense.  Something like:
> 
> 		if (!bh) {
> 			:
> 			:
> +			if (filp->f_pos > inode->i_blocks << 9) {
> +				break;
> 			filp->f_pos += sb->s_blocksize - offset;
> 			continue;
> 		}
> 
> This obviously won't help if the whole inode is bogus, but then nothing
> will catch all errors.

Yep, I'd thought maybe a size vs. blocks test might make sense; I think
there can never legitimately be a sparse directory?

I guess if the intent is to soldier on in the face of adversity, it
doesn't matter if it's an umappable offset or an IO error; ext3 wants to
go ahead & try the next one block anyway.  So the size test probably
makes sense as a stopping point.

Thanks for the comments,

-Eric
