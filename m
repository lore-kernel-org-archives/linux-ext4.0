From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] Revert "Revert "math64: New div64_u64_rem helper""
Date: Wed, 4 Sep 2013 13:55:29 -0400
Message-ID: <20130904175529.GA25526@redhat.com>
References: <1376078164-23147-1-git-send-email-snitzer@redhat.com>
 <CAOMFOmXhoBoFrkr8bgP5qV-jZXA=6ZfXnSsg1j5fEVv_RgRAyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@kernel.org>, linux-ext4@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOMFOmXhoBoFrkr8bgP5qV-jZXA=6ZfXnSsg1j5fEVv_RgRAyw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 04 2013 at 12:11pm -0400,
Anatol Pomozov <anatol.pomozov@gmail.com> wrote:

> Hi,
> 
> On Fri, Aug 9, 2013 at 12:56 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> > This reverts commit f3002134158092178be81339ec5a22ff80e6c308.
> >
> > div64_u64_rem was removed because there were no other users.
> 
> In the light of this discussion https://lkml.org/lkml/2013/8/30/417 we
> will have more users of div64_u64_rem
> 
> For example code from ext4_mb_find_by_goal() function uses function
> do_div() with divisor sbi->s_stripe that has "unsigned long" type.
> do_div() silently truncates the type to 32bits and do_div() returns
> incorrect result (or crash if lower 32bits are zero). It should be
> either replaced with div64_u64_rem() posted here or with just "a % b".

Hi,

As Ingo suggested, I went ahead and introduced a completely new
div64_u64_rem, see: https://lkml.org/lkml/2013/8/21/452

I've staged this change in linux-next for inclusion in the current 3.12
merge (via the device-mapper tree), see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=eb18cba78c2b9250663021e17e1e9cc34630e92a

So once this is in ext4 can make use of div64_u64_rem().

Mike
