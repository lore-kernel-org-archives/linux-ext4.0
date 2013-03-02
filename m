From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix possible memory leak in ext4_remount()
Date: Sat, 2 Mar 2013 17:13:39 -0500
Message-ID: <20130302221339.GC22941@thunk.org>
References: <CAPgLHd-J=j=aVCpjutq2B1+NMqxz=v50xNcEQA_57Ni_7v9HKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, yongjun_wei@trendmicro.com.cn,
	linux-ext4@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50956 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab3CBWNq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Mar 2013 17:13:46 -0500
Content-Disposition: inline
In-Reply-To: <CAPgLHd-J=j=aVCpjutq2B1+NMqxz=v50xNcEQA_57Ni_7v9HKA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 27, 2013 at 01:18:53PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> 'orig_data' is malloced in ext4_remount() and should be freed
> before leaving from the error handling cases, otherwise it will
> cause memory leak.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, applied.

					- Ted
