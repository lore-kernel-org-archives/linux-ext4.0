From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: suspiciously good fsck times?
Date: Thu, 10 Jul 2008 13:27:40 -0400
Message-ID: <4876468C.2040005@redhat.com>
References: <4876025A.80909@gmail.com> <20080710151822.GA25939@mit.edu> <48762F9F.5070308@redhat.com> <48763564.2090505@redhat.com> <20080710172117.GE10402@mit.edu>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757464AbYGJR1m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Jul 2008 13:27:42 -0400
In-Reply-To: <20080710172117.GE10402@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Jul 10, 2008 at 11:14:28AM -0500, Eric Sandeen wrote:
>   
>> Val & I talked about this a little, and came to the conclusion that
>> directory fragmentation might be a pretty big part of it.
>>     
>
> Hmm, could be.  Let's see.  Ric said 46.5 million files, I don't know
> how big the filenames were, but let's assume a directory entry size of
> 32, so that means if we assume perfect packing, 128 directory entries
> per 4k block.  Let's use 100 directory entries/blok just to make the
> math easyer, so that's 465,000 blocks.  If we assume a 10ms seek time,
> and that the blocks are totally scattered, that's 4650 seconds, or
> 1.29 hours. So that's roughly within the ballpark that Ric measured.
>
>      	       	      	      	     	 	  - Ted
>   

(changing cc to the real list instead of ext4 owner - sorry!)

The file names are 40 bytes long, (6 initial bytes of time stamp with 24 
random bytes at end of name. For example:

451aeb61ead89~~~DYASX8LYL4NAUWK3WI187VRP

The 4 threads chose the target subdirectory based on the time stamp, 
rotating into a new subdirectory every 3 minutes or so.

ric



