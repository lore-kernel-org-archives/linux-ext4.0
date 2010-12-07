From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] ext2: speed up file creates by optimizing rec_len
 functions
Date: Tue, 07 Dec 2010 15:36:32 -0600
Message-ID: <4CFEA8E0.9030501@redhat.com>
References: <4CFE7347.8030807@redhat.com>	<4CFE7409.9090609@redhat.com>	<20101207130708.71c894e9.akpm@linux-foundation.org>	<4CFEA5AF.2000702@redhat.com> <20101207133308.eb2144da.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab0LGVgj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Dec 2010 16:36:39 -0500
In-Reply-To: <20101207133308.eb2144da.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/7/10 3:33 PM, Andrew Morton wrote:
> I bet other tweaks in there would yield similar goodliness.

Yep, probably so ...

We could also speed up ext3/4 a bit by not doing the extN_check_dir_entry
call on every single access, but only when we read it from disk.

Given that I've talked about it for 4 years and never done it, maybe
I'll try to find a volunteer ;)

-Eric
