From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH 1/2] ext4: get free blocks count of BLOCK_UNINIT groups from group desc directly
Date: Mon, 1 Aug 2011 21:15:11 -0600
Message-ID: <0B54C612-6561-4EFD-894B-59CC27ABE2BA@gmail.com>
References: <1311168774-26378-1-git-send-email-xiaoqiangnk@gmail.com> <1311168774-26378-2-git-send-email-xiaoqiangnk@gmail.com> <20110801112015.GB21388@thunk.org>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60042 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab1HBDOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Aug 2011 23:14:43 -0400
Received: by pzk37 with SMTP id 37so12652406pzk.1
        for <linux-ext4@vger.kernel.org>; Mon, 01 Aug 2011 20:14:43 -0700 (PDT)
In-Reply-To: <20110801112015.GB21388@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-01, at 5:20 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Jul 20, 2011 at 09:32:53PM +0800, Yongqiang Yang wrote:
>> This patch teaches ext4 to get free blocks count of BLOCK_UNINIT groups from
>> group desc directly.
>> 
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> 
> The reason why we weren't doing this is because older versions of
> e2fsprogs I don't think set the free blocks count correctly.  Or at
> least, I have a vague memory that this was the case.  I'll have to do
> some code archeology before can be 100% sure this is safe to do.

I think the other reason is that this gives the kernel code some flexibility in how the group is formatted (e.g. flex_bg or whatever may move allocated blocks around).

Cheers, Andreas