From: Clement Gallin-Douathe <c-gallin-douathe@ti.com>
Subject: Re: kernel oops in jbd2_journal_get_descriptor_buffer
Date: Thu, 11 Oct 2012 17:22:49 +0200
Message-ID: <5076E449.5000004@ti.com>
References: <50768765.8040406@ti.com> <20121011095932.GA16624@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:48963 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab2JKPW6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2012 11:22:58 -0400
In-Reply-To: <20121011095932.GA16624@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan,

Thanks for your answer.
I have checked and I have no tricks with mapping flags (mount ext4 
options : rw,nosuid,nodev,noatime,errors=continue,data=ordered)
I have added high mem verification on grow_dev_page function just after 
the page creation with find_or_create_page function.
PageHighMem() is not null.
So you think, it's a good idea to look into mm/page_alloc.c and verify 
gfp flags?

regards,

Clement

On 10/11/2012 11:59 AM, Jan Kara wrote:
> !__GFP_HIGH in particular. So does the device ext4 is mounted on play
> some tricks with mapping fl


