From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add regression tests for ^extents punch hole
Date: Tue, 24 Feb 2015 19:24:37 -0500
Message-ID: <20150225002437.GB3782@thunk.org>
References: <4c557308eb4e62752dc8b513495cb6d46ca5775d.1424730653.git.osandov@osandov.com>
 <20150223224620.GL12722@dastard>
 <alpine.LFD.2.00.1502241106110.28736@localhost.localdomain>
 <20150224113108.GA4251@dastard>
 <alpine.LFD.2.00.1502241249300.28736@localhost.localdomain>
 <20150224124938.GB4251@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Omar Sandoval <osandov@osandov.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150224124938.GB4251@dastard>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 24, 2015 at 11:49:38PM +1100, Dave Chinner wrote:
> 
> Ah, right, I said that was during the discussion about the commit I
> quoted above. You convinced me that we shouldn't cater for special
> cases like this and instead iterate mkfs/mount configurations.

I was in favor of iterating over mkfs/mount configurations myself --
and that's something I do, but it takes around 20 hours to run all of
the iterations, so it's not something I'm doing _all_ that often.

> I think the test should still be generic and block size independent,
> but if you want to force ext4 to turn off the extents flag, then
> use something like this:

I suspect our current generic fsstress and fsx tests would catch this
already, and what I need to do is to make sure I add ext3/1k to my
test configurations (currently I test an ext3 configuration, and a 1k
block configuration, but I don't currently test ext3/1k together).
That would probably round out my full test iteration to a very
pleasing 24 hours or so, which is fine, although I wouldn't want it to
take much longer than that.


> /me shakes his head, wonders how other maintainers stay sane

They're coming to take me away, ha-haaa.
They're coming to take me away, ho ho, he he , ha ha,
To the happy home with trees and flowers and chirping birds
And basket weavers who sit and smile
And twiddle their thumbs and toes
And they're coming to take me away, ha-haaa!

:-)

						- Ted
