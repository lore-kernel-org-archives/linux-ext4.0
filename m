From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: mballoc: Fix spectre gadget in
 ext4_mb_regular_allocator
Date: Mon, 30 Jul 2018 15:38:06 -0400
Message-ID: <20180730193806.GW21725@thunk.org>
References: <20180730180747.25200-1-jcline@redhat.com>
 <20180730183615.GU21725@thunk.org>
 <3f954645-e6b5-55d8-0ccd-2d1dd5ddb80e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>, stable@vger.kernel.org
To: Jeremy Cline <jcline@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3f954645-e6b5-55d8-0ccd-2d1dd5ddb80e@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 30, 2018 at 02:46:59PM -0400, Jeremy Cline wrote:
> I dropped patch 1/3 and 2/3 from the original series because they can
> both be covered by some sanitation in fs/quota/quota.c, so the this is
> only patch from the v1 series that should be applied.
> 
> Sorry for not being more clear!

Great, thanks for the clarification!  I'll review the patch posthaste!

      	      	      		      	   	  - Ted
