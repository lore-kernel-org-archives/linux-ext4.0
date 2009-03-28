From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: Simple inode question (ext2/3)
Date: Sat, 28 Mar 2009 00:57:44 -0700 (PDT)
Message-ID: <22754510.post@talk.nabble.com>
References: <alpine.DEB.2.00.0902241713520.16614@pintail.doc.ic.ac.uk> <20090224190709.GG5482@mit.edu> <alpine.DEB.2.00.0902241932530.2000@pintail.doc.ic.ac.uk> <20090224210515.GA7064@mit.edu> <alpine.DEB.2.00.0902242148450.13652@pintail.doc.ic.ac.uk> <20090225040654.GT3199@webber.adilger.int> <417E5333-32B8-42AA-A498-011DF1DDB074@doc.ic.ac.uk> <20090225143821.GH7064@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:42868 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbZC1H5s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Mar 2009 03:57:48 -0400
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1LnTQG-0006AY-8I
	for linux-ext4@vger.kernel.org; Sat, 28 Mar 2009 00:57:44 -0700
In-Reply-To: <20090225143821.GH7064@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>




Theodore Tso wrote:
> 
> On Wed, Feb 25, 2009 at 10:59:22AM +0000, Felipe Franciosi wrote:
>> As a matter of fact, I didn't see any critics to the question below. I  
>> can only assume that messing with inodes can look academic or not  
>> depending on the phase of the moon or something.
>>
>> On 6 Jan 2009, at 10:36, Rohit Sharma wrote:
>>> I want to read data blocks from one inode
>>> and copy it to other inode.
>>>
>>> I mean to copy data from data blocks associated with one inode
>>> to the data blocks associated with other inode.
>>>
>>> Is that possible in kernel space.?
>>> --
> 
> 
> 
> Actually, I asked Rohit what they were doing back September, 2008.
> 
> http://article.gmane.org/gmane.comp.file-systems.ext4/9142
> 
> Personally, I'm not really convinced by the approach which the fscops
> project is adopting, but that's up to them to figure out.  I was
> amused though by their powerpoint slides which claim that they are "on
> the way to being accepted in the mainline kernel" --- that seems a
> little gradious, given that they haven't even submitted any code for
> review yet.
> 
> 

Hi Ted,

I know we became a bit futuristic at that point in time when we saw a mail 
from Akira mentioning that you guys are planning to provide a ABI to provide
block allocation in restricted block group range(s), option(2) in the
following mail.

http://patchwork.ozlabs.org/patch/12877/

which would have made the OHSM work more simpler and compatible with
the current linux framework. 


Also, there was a piece of code submitted from our end too, as a support to
the above option(2)

http://kerneltrap.org/mailarchive/linux-ext4/2009/1/26/4813934

asking if it would be feasible, if we go ahead and implement the same
for ext4.

Later, when we realised the complexities involved and saw some replies from
your end regarding the concept of OHSM. We have started being more cautious.

I believe we have also sent a recent reply to one of your mails on the
feedback to the idea of OHSM. It would be great if you can just pull out
some small amount of time to have a look at it atleast.

http://www.nabble.com/-RFC--PATCH-0-3--ext4%3A-online-defrag-(ver-1.0)-tc21742025.html

Thanks & Regards,
Rishi.



> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
View this message in context: http://www.nabble.com/Simple-inode-question-%28ext2-3%29-tp22186566p22754510.html
Sent from the linux-ext4 mailing list archive at Nabble.com.

