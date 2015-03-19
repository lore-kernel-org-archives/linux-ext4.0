From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fs corruption recovery
Date: Thu, 19 Mar 2015 16:52:01 -0500
Message-ID: <550B4501.8080200@redhat.com>
References: <550A1EBF.2030902@linux.vnet.ibm.com> <3D9B0893-DA8D-41D1-8782-BC966B91D44D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"jane@us.ibm.com" <jane@us.ibm.com>,
	"marcel.dufour@ca.ibm.com" <marcel.dufour@ca.ibm.com>
To: Andreas Dilger <adilger@dilger.ca>,
	Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbbCSVwL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Mar 2015 17:52:11 -0400
In-Reply-To: <3D9B0893-DA8D-41D1-8782-BC966B91D44D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/18/15 7:59 PM, Andreas Dilger wrote:
> I think that running a 17TB filesystem on ext3 is a recipe for disaster.  They should use ext4 for anything larger than 16TB.

Not only that - impossible, unless you have > 4k page sizes and > 4k blocks.

# mkfs.ext3: Size of device fsfile too big to be expressed in 32 bits
	using a blocksize of 4096.

Are they doing something clever on PPC w/ 64k blocks?

-Eric

> Upgrading e2fsprogs to the latest 1.42.12 is also strongly advised.   
> 
> Cheers, Andreas
> 
>> On Mar 18, 2015, at 18:56, Allison Henderson <achender@linux.vnet.ibm.com> wrote:
>>
>> Hi all,
>>
>> I've had some internal folks contact me for help with some
>> customers that are having file system corruption woes. It's been so
>> long since I've done any work on ext3/4 code it's hard for me to
>> advise. So I told them I would run the situation by the folks on
>> these mailing lists to see if I can generate some more ideas for
>> them.
>> 
>> They have a 17 TB ext3 file system on rhel 6.5. Upon reboot, the
>> system was not able to come up and reported errors with the super
>> block.  Right now, getting the machine to boot is not a critical as
>> just recovering customer data. They are able to boot a rescue disk
>> to run fsck and they report that it ran for a short while and
>> showed a lot of inode errors, but eventually it seg faulted. They
>> can re-run the tool, and they were able to progress further on
>> repeated runs, but they do not seem to be able to get further than
>> about 75%. They do not have the fsck core at this point in time,
>> but I'm guessing the tool is likely running out of memory for a
>> file system that large, and they say they are using an old fsck
>> (from 2010). They report having run fsck successfully on large file
>> systems in the past, but normally the machine has 24GB, and this
>> one has only 16GB due to a bad dim. The plan at the moment is for
>> them to fix the bad dim and try the latest fsck.
>> 
>> So the questions they had that I am hoping to get help for is are
>> there any other options they can try for data recovery? I am hoping
>> that the extra memory and the updated fsck might be able to
>> complete, but I'm not sure what has changed in the tool since then.
>> I can assist them to collect more information/cores. Any help is
>> appreciated! Thx!
>> 
>> Allison Henderson
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

