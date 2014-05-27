From: Niu Yawei <yawei.niu@gmail.com>
Subject: Re: [PATCH 1/3] quota: protect Q_GETFMT by dqonoff_mutex
Date: Tue, 27 May 2014 18:28:14 +0800
Message-ID: <538468BE.8000203@gmail.com>
References: <537DD5BA.1050105@gmail.com> <538464AD.6050407@gmail.com> <20140527101219.GA28035@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	yawei.niu@intel.com, andreas.dilger@intel.com, jack@suse.cz,
	lai.siyao@intel.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44667 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaE0K2N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 May 2014 06:28:13 -0400
In-Reply-To: <20140527101219.GA28035@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ok, thanks.
> On Tue, May 27, 2014 at 06:10:53PM +0800, Niu Yawei wrote:
>> Remove dqptr_sem to make quota code scalable (but kept in struct
>> quota_info to keep kernel ABI unchanged):
> There is not stable kernel ABI to be kept, please adjust your patch for
> that.
>

