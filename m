From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Testing performance of SSDs using ext4 and effect on parameters
Date: Mon, 23 Jun 2014 10:07:47 -0500
Message-ID: <53A842C3.1070302@redhat.com>
References: <CAHohGC-fW0CEALotEY_93t=n7a3URZYAsAp2G2EytuRgBBdgtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: rishabh.singh.cse11@iitbhu.ac.in,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900AbaFWPHt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2014 11:07:49 -0400
In-Reply-To: <CAHohGC-fW0CEALotEY_93t=n7a3URZYAsAp2G2EytuRgBBdgtw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/22/14, 11:30 PM, Rishabh Singh B.Tech., CSE, IIT-BHU, Varanasi (INDIA) wrote:
> Hi,
> 
> I am testing the performance of SSDs using the ext4 file system in
> Ubuntu. I want to test the effects on performance by changing
> parameters:
> 1.data=writeback or ordered
> 2.barriers
> 3.noatime
> 4.errors
> 
> Can you kindly suggest me how do I change the desired parameters for
> testing? And some other resouces that are helpful.

Please read the mount(8) and tune2fs(8) manpages:

# man 8 mount
# man 8 tune2fs

-Eric

