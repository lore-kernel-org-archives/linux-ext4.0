From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: lock i_mutex for fallocate?
Date: Wed, 31 Aug 2011 18:12:04 -0700
Message-ID: <4E5EDBE4.8010604@linux.vnet.ibm.com>
References: <4E5ED2D5.8040302@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50986 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894Ab1IABMJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 21:12:09 -0400
In-Reply-To: <4E5ED2D5.8040302@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oh, I meant for this to go to linux-fsdevel instead of linux-kernel, but 
all feedback is welcome!  :)

On 08/31/2011 05:33 PM, Allison Henderson wrote:
> Hi All,
>
> In ext4 punch hole, we realized that the punch hole operation needs to
> be done under i_mutex just like truncate. i_mutex for truncate is held
> in the vfs layer, so we dont need to lock it at the file system layer,
> but vfs does not lock i_mutex for fallocate. We can lock i_mutex for
> fallocate at the fs layer, but question was raised then: should i_mutex
> for fallocate be held in the vfs layer instead? I do not know if other
> file systems need i_mutex to be locked for fallocate, or if they might
> be locking it already, so I am doing some investigating on this idea,
> and also the appropriate use of i_mutex in general. Can someone provide
> some insight this topic? Thx!
>
> Allison Henderson

