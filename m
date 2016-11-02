From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 0/6] vfs: Add timestamp range check support
Date: Thu, 3 Nov 2016 09:48:27 +1100
Message-ID: <20161102224827.GJ14023@dastard>
References: <1478099096-25637-1-git-send-email-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, tglx@linutronix.de, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, tytso@mit.edu, viro@zeniv.linux.org.uk,
        y2038@lists.linaro.org, linux-afs@lists.infradead.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478099096-25637-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 02, 2016 at 08:04:50AM -0700, Deepa Dinamani wrote:
> The series is aimed at adding timestamp checking and policy
> related to it to vfs.
> 
> The series was developed with discussions and guidance from
> Arnd Bergmann.
> 
> The original idea for the series was the discussion:
> https://lkml.org/lkml/2014/5/30/551
> 
> Patches 5 and 6 can be merged only after vfs is transitioned
> to use 64 bit timestamps as noted in the respective commit
> texts.
> 
> The series only includes adding range limits to filesystems:
> ext4 and afs as examples to keep the series simple.
> Every filesystem will be updated to add these limits.

We're going to need regression tests for this to ensure that it
works properly and that we don't inadvertantly break it in future.
Can you write some xfstests that exercise this functionality and
validate that the mount behaviour, clamping and range limiting is
working as intended?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
