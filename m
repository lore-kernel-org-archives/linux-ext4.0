Return-Path: <SRS0=VEyz=NL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:55596 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728578AbeJaMfi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 31 Oct 2018 08:35:38 -0400
Subject: Re: [PATCH v2 11/11] ext4: access to uninitialized bh fields in
 ext4_xattr_set_handle()
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
References: <cover.1540935522.git.vvs@virtuozzo.com>
 <b8523c3a-0eb2-3aeb-fdf9-2e9d6d320d5c@virtuozzo.com>
 <48BA929C-9BF7-4092-BDD3-BECB64AF0599@dilger.ca>
From: Vasily Averin <vvs@virtuozzo.com>
Message-ID: <0db97e14-c87d-9507-4c87-875835b64212@virtuozzo.com>
Date: Wed, 31 Oct 2018 06:39:20 +0300
MIME-Version: 1.0
In-Reply-To: <48BA929C-9BF7-4092-BDD3-BECB64AF0599@dilger.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/31/2018 04:30 AM, Andreas Dilger wrote:
> Could you please explain your statement below that on-stack
> initialization does not zero unspecified fields?  According 
> to documents I found, for example:
> 
> https://gcc.gnu.org/onlinedocs/gcc/Designated-Inits.html
> 
> they *are* initialized to zero. 

I did not know it,
I re-checked it in generated assembler code and found that you are right and I was wrong.

Please drop this patch,
should I resend of rest of this patch set once again?

Thank you,
	Vasily Averin
