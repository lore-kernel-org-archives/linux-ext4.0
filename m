From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: convert to use leXX_add_cpu()
Date: Thu, 27 Sep 2012 09:39:29 -0400
Message-ID: <20120927133929.GA12317@thunk.org>
References: <CAPgLHd-2+KkFZAHjU01Muuyqf_xkA4R6E9RF=c0Z1OMROmieGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, yongjun_wei@trendmicro.com.cn,
	linux-ext4@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52687 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab2I0Nje (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2012 09:39:34 -0400
Content-Disposition: inline
In-Reply-To: <CAPgLHd-2+KkFZAHjU01Muuyqf_xkA4R6E9RF=c0Z1OMROmieGw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 26, 2012 at 10:00:15PM -0000, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Convert cpu_to_leXX(leXX_to_cpu(E1) + E2) to use leXX_add_cpu().
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied, thanks.

					- Ted
