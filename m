From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: mballoc: Fix spectre gadget in
 ext4_mb_regular_allocator
Date: Mon, 30 Jul 2018 14:36:15 -0400
Message-ID: <20180730183615.GU21725@thunk.org>
References: <20180730180747.25200-1-jcline@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>, stable@vger.kernel.org
To: Jeremy Cline <jcline@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180730180747.25200-1-jcline@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hey Jeremy,

I think you are also going to be changing the 1/3 patch from the
original patch series that this was part of.  That's correct, right?

It would be easier for me if you could simply make all of the
revisions you plan to make for the patch series, and then upload a
full v2 of the entire patch series.

Right now I've mentally marked the entire patch series as "waiting
forh v2".  So when you send a V2 version of individual patch out of
that series, it leaves things unclear when/if you plan to update any
of other patches in the series.

Thanks!!

						- Ted
