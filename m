From: Felipe Franciosi <ozzy@doc.ic.ac.uk>
Subject: Re: Simple inode question (ext2/3)
Date: Wed, 25 Feb 2009 10:59:22 +0000
Message-ID: <417E5333-32B8-42AA-A498-011DF1DDB074@doc.ic.ac.uk>
References: <20090224210515.GA7064@mit.edu> <alpine.DEB.2.00.0902242148450.13652@pintail.doc.ic.ac.uk> <20090225040654.GT3199@webber.adilger.int>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.217.174]:58954 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbZBYK71 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 05:59:27 -0500
Received: by gxk22 with SMTP id 22so8434572gxk.13
        for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 02:59:25 -0800 (PST)
In-Reply-To: <20090225040654.GT3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

On 25 Feb 2009, at 04:06, Andreas Dilger wrote:

> On Feb 24, 2009  21:48 +0000, Felipe Franciosi wrote:
>>> This isn't for some college class, is it?
>>
>> No, it is not. Where would you get that idea from?
>
> Because there are lots of questions like this from university
> students that would rather have the mailing list do their
> homework for them.

I'm sorry, but quite honestly, I don't think my questions looked like  
"hey, can someone do this for me?".

I've had replies from other people in the list. Some with similar  
questions, but believe me, AFRAID of asking them publicly exactly  
because you can get this kind of reply.

And as I've said to another member of the list that also contacted me  
privately: I'd rather help students with humble and honest questions  
than developers that lie about their skills to get a job and then go  
to mailing lists to get their work done for them.

> How sad that you have just been rude one of the main ext2/3/4  
> developers,
> e2fsprogs maintainer, and one of the most senior Linux kernel  
> developers.

I know exactly who he is and how good he is (at least, technically),  
because I follow this list's discussions. I just don't see how he is  
helping by not only refusing to answer, but also constantly and  
publicly asking questions about my intentions in an offensive manner,  
already criticising the way I'm experimenting something.

> I would suggest that you look at what ext2_iget->ext2_get_inode() is  
> doing.

Thank you. This is the kind of reply I was expecting. Much appreciated.

> You will have a hard time getting much help from the list unless you  
> change
> your attitude.

Unless some people stand up and say something about this type of reply  
from time to time, NO ONE is getting any help here.

As a matter of fact, I didn't see any critics to the question below. I  
can only assume that messing with inodes can look academic or not  
depending on the phase of the moon or something.

------------------8<------------------
On 6 Jan 2009, at 10:36, Rohit Sharma wrote:
> I want to read data blocks from one inode
> and copy it to other inode.
>
> I mean to copy data from data blocks associated with one inode
> to the data blocks associated with other inode.
>
> Is that possible in kernel space.?
> --
------------------8<------------------

My very best,
Felipe
