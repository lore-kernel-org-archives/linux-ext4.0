From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: serialize unaligned asynchronous DIO
Date: Thu, 13 Jan 2011 22:41:10 -0600
Message-ID: <4D2FD3E6.1000509@redhat.com>
References: <4D2F7B52.1040209@redhat.com> <20110114041514.GI31800@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115Ab1ANElP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Jan 2011 23:41:15 -0500
In-Reply-To: <20110114041514.GI31800@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/13/11 10:15 PM, Ted Ts'o wrote:
> On Thu, Jan 13, 2011 at 04:23:14PM -0600, Eric Sandeen wrote:
>> Mingming suggested that perhaps we can track outstanding
>> conversions, and wait on that instead so that non-sparse
>> files won't be affected, but I've had trouble making that
>> work so far, and would like to get the corruption hole
>> plugged ASAP.  Perhaps adding a prink_once() warning of
>> the perf degradation on this path would be useful?
> 
> Yeah, I think a printk_once(), or maybe better yet, a warning
> ext4_msg() ratelimited to once a day, is the way to go.  I'd print the
> inode number and process name that did the offending async DIO, so it
> can help out the system administrator.

I'll add something like that.

> I've looked over the rest of the patch, and it seems good.  Just one
> question:
> 
>> +static int
>> +ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
>> +		unsigned long nr_segs, loff_t pos)
>> +{
>> +	struct super_block *sb = inode->i_sb;
>> +	int blockmask = sb->s_blocksize - 1;
>> +	size_t count = iov_length(iov, nr_segs);
>> +	loff_t final_size = pos + count;
>> +
>> +	if (pos >= inode->i_size)
>> +		return 0;
> 
> Why is it ok if the write is extended the file?  Are you depending on
> some other lock (i_data_sem, perhaps?) to serialize the write in that
> case?  If so, could you please add a comment to that effect?

We only have this problem if we are going down the unwritten extent
route, which only happens for writes inside i_size:

        if (rw == WRITE && final_size <= inode->i_size) {
                /*
                 * We could direct write to holes and fallocate.
		   ...

I can add a comment, good point.  In fact I'll liberally add a few
comments, sorry, I usually do that but didn't tidy this patch up
prior to sending.  :)

-Eric
 
>        	      	    	       	     	     - Ted

