From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fiemap support for ext3
Date: Wed, 23 Apr 2008 18:48:25 -0500
Message-ID: <480FCAC9.8050105@redhat.com>
References: <20080423193914.GA25173@unused.rdu.redhat.com> <20080423232725.GK3095@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbYDWXsc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Apr 2008 19:48:32 -0400
In-Reply-To: <20080423232725.GK3095@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Apr 23, 2008  15:39 -0400, Josef Bacik wrote:

>> +	/*
>> +	 * we want the comparisons to be unsigned, in case somebody passes -1,
>> +	 * meaning they want they want the entire file, but the result has to be
>> +	 * signed so we can handle the case where we get more blocks than the
>> +	 * size of the file
>> +	 */
>> +	length = (long)min((unsigned long)fiemap_s->fm_length,
>> +			   (unsigned long)i_size_read(inode));
> 
> This might be written as:
> 
> 	length = (long)min_t(unsigned long,fiemap_s->fm_len,i_size_read(inode));
> 
> Also, what about files that have blocks mapped after i_size?

That'll be tough for ext3, though I guess for a generic interface it
could happen, so I guess it needs to be handled.  Maybe check i_blocks
against i_size, see if i_blocks indicates blocks past EOF?  Hm, I guess
that's not going to work in general; you could be completely sparse up
to an EOF at 100G and have 100M of blocks past that...

I don't know how you'd handle this in the generic case...?

-Eric
