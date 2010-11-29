From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Userspace tool to invoke FITRIM?
Date: Mon, 29 Nov 2010 12:21:00 -0600
Message-ID: <4CF3EF0C.30700@redhat.com>
References: <AANLkTi=SQ-keJgV2-ZuuARxKRr+8YpPBrop_+n4NXKr0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab0K2SVD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Nov 2010 13:21:03 -0500
In-Reply-To: <AANLkTi=SQ-keJgV2-ZuuARxKRr+8YpPBrop_+n4NXKr0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/29/10 12:10 PM, Greg Freemyer wrote:
> All,
> 
> Is there a userspace tool to invoke FITRIM for ext4 yet?
> 
> Is it incorporated into the normal userspace ext2/ext3/ext4 collection?
> 
> Thanks
> Greg

It has been submitted/merged to util-linux-ng, as it is not an ext4-specific tool.

http://www.spinics.net/lists/util-linux-ng/msg03646.html

-Eric
