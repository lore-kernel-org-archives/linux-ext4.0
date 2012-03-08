From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [RFC] ext4: block reservation allocation
Date: Thu, 08 Mar 2012 11:39:11 -0500
Message-ID: <4F58E0AF.3010207@ubuntu.com>
References: <20120227090901.GA13953@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:9309 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab2CHQjN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Mar 2012 11:39:13 -0500
In-Reply-To: <20120227090901.GA13953@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/27/2012 4:09 AM, Zheng Liu wrote:
> Hi list,
>
> Now, in ext4, we have multi-block allocation and delay allocation. They work
> well for most scenarios. However, in some specific scenarios, they cannot help
> us to optimize block allocation. For example, the user may want to indicate some
> file set to be allocated at the beginning of the disk because its speed in this
> position is faster than its speed at the end of disk.

I thought this could be done with the new defrag api.  I thought it had 
a way to allocate a new donor file in a specific location so you could 
then migrate the target file to those specific donor blocks.


