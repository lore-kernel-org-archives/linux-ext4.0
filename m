From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -next] ext4: fix missing unlock on error in
 ext4_punch_hole()
Date: Tue, 18 Jun 2013 11:05:28 -0400
Message-ID: <20130618150528.GA7359@thunk.org>
References: <CAPgLHd-2_uHg9q_7nQway8uCigH=wgXxiGm9auYDNL_pByzJHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: liwang@ubuntukylin.com, adilger.kernel@dilger.ca,
	yongjun_wei@trendmicro.com.cn, linux-ext4@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59026 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab3FRPFo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Jun 2013 11:05:44 -0400
Content-Disposition: inline
In-Reply-To: <CAPgLHd-2_uHg9q_7nQway8uCigH=wgXxiGm9auYDNL_pByzJHA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 18, 2013 at 11:40:34AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock before return from function ext4_punch_hole()
> in the error handling case.
> Introduced by commit 1cdec9ca46c2c2a7ce452659f43dac64ad5fbc85.
> (ext4: Avoid unnecessarily writing back dirty pages before hole punching)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Hi Wei,

Thanks for pointing this out!  I've folded this patch into the commit
"ext4: avoid unnecessarily writing back dirty pages before hole
punching".

					- Ted
