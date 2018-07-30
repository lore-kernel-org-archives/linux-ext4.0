From: Jeremy Cline <jcline@redhat.com>
Subject: Re: [PATCH v2] ext4: mballoc: Fix spectre gadget in
 ext4_mb_regular_allocator
Date: Mon, 30 Jul 2018 14:46:59 -0400
Message-ID: <3f954645-e6b5-55d8-0ccd-2d1dd5ddb80e@redhat.com>
References: <20180730180747.25200-1-jcline@redhat.com>
 <20180730183615.GU21725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>, stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180730183615.GU21725@thunk.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

On 07/30/2018 02:36 PM, Theodore Y. Ts'o wrote:
> Hey Jeremy,
> 
> I think you are also going to be changing the 1/3 patch from the
> original patch series that this was part of.  That's correct, right?
> 
> It would be easier for me if you could simply make all of the
> revisions you plan to make for the patch series, and then upload a
> full v2 of the entire patch series.
> 
> Right now I've mentally marked the entire patch series as "waiting
> forh v2".  So when you send a V2 version of individual patch out of
> that series, it leaves things unclear when/if you plan to update any
> of other patches in the series.

I dropped patch 1/3 and 2/3 from the original series because they can
both be covered by some sanitation in fs/quota/quota.c, so the this is
only patch from the v1 series that should be applied.

Sorry for not being more clear!

Cheers,
Jeremy
