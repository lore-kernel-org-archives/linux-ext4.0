From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Sun, 18 May 2008 22:03:55 +0200
Message-ID: <8763tbcrbo.fsf@basil.nowhere.org>
References: <482DDA56.6000301@redhat.com>
	<20080516130545.845a3be9.akpm@linux-foundation.org>
	<482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org>
	<482E08E6.4030507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <482E08E6.4030507@redhat.com> (Eric Sandeen's message of "Fri, 16 May 2008 17:21:26 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen <sandeen@redhat.com> writes:
>
> Right, that was the plan.  I wasn't really going to stand there and pull
> the plug.  :)  I'd like to get to "out of $NUMBER power-loss events
> under this usage, I saw $THIS corruption $THISMANY times ..."

I'm not sure how good such exact numbers would do. Surely power down
behaviour that would depend on the exact disk/controller/system
combination? Some might be better at getting data out at 
power less, some might be worse.

To get a good picture, you would probably need to do such tests
over a wide range of systems and put all the data together, but
even then you couldn't be sure you covered all well.

For a distributor it would probably make more sense to do such
tests as part of system certification and then modify the defaults
to match all tested systems. But that doesn't really work
for good mainline defaults.

I suspect for mainline the only good default is to be very conservative.

-Andi
