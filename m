From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: merging of two file system
Date: Mon, 28 Jul 2008 11:59:24 -0700 (PDT)
Message-ID: <18697116.post@talk.nabble.com>
References: <425904320807270905k32264faaq5c813b73000ee5c6@mail.gmail.com> <20080727225246.GD7922@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:40994 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYG1S71 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 14:59:27 -0400
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1KNXwK-0003rx-TH
	for linux-ext4@vger.kernel.org; Mon, 28 Jul 2008 11:59:24 -0700
In-Reply-To: <20080727225246.GD7922@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Theodore Tso wrote:
> 
> On Sun, Jul 27, 2008 at 09:35:30PM +0530, Vineet Agarwal wrote:
>> can we merge two file system into one in ext2/3 ?
> 
>>What exactly do you mean by that?
> 
> 

What I understand is that, he means to say that is there any existing
mechanism or support by which we can merger two ext2/ext3 file systems on
the fly.
i.e. One of them would be the primary and the other would be a secondary.
The secondary after merging will reside in the directory structure of the
primary file system.

HTH,

Thanks,
SandeepKsinha



> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
View this message in context: http://www.nabble.com/merging-of-two-file-system-tp18677733p18697116.html
Sent from the linux-ext4 mailing list archive at Nabble.com.

