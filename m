From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: BUG with delayed allocation
Date: Wed, 19 Mar 2008 09:42:13 -0500
Message-ID: <47E12645.40203@redhat.com>
References: <20080319085235.GA6752@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758181AbYCSTno (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2008 15:43:44 -0400
In-Reply-To: <20080319085235.GA6752@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Hi,
> 
> Eric actually observed it yesterday. I am able to reproduce it locally.
> With delayed allocation we are observing wrong value of i_size.
> 
> kenrel: 2.6.25-rc5 +
> With all the patches in the patch queue

...

I also see this with only:

patches/delalloc-vfs.patch
patches/delalloc-ext4.patch

applied.

-Eric
