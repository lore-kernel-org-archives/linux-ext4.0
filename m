From: Dave Chinner <david@fromorbit.com>
Subject: Re: regression: 4.13 cannot follow symlinks on some ext3 fs
Date: Tue, 28 Nov 2017 11:42:13 +1100
Message-ID: <20171128004213.GQ4094@dastard>
References: <20171123233101.GP2482@two.firstfloor.org>
 <700971AC-BDE2-4993-BD56-7497AD8A0FC4@dilger.ca>
 <20171124020435.GQ2482@two.firstfloor.org>
 <C656DD8B-7521-4281-8D55-4416A3C75161@dilger.ca>
 <20171124165102.GS2482@two.firstfloor.org>
 <706E8F37-95C7-4321-AACA-2ED11F82E625@dilger.ca>
 <20171125223202.GL4094@dastard>
 <20171126154026.2cyhh3vsvhnszhvs@thunk.org>
 <20171126211427.GO4094@dastard>
 <20171127171125.dlrw7fng7p7onufl@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
        Andi Kleen <andi@firstfloor.org>,
        Tahsin Erdogan <tahsin@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171127171125.dlrw7fng7p7onufl@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 27, 2017 at 12:11:26PM -0500, Theodore Ts'o wrote:
> On Mon, Nov 27, 2017 at 08:14:27AM +1100, Dave Chinner wrote:
> > Of course. I've done that every time I've come acros these sorts of
> > problems.
> 
> The most recent report I was able to find was against 4.7-rc6, in July
> 2016.  Have you been able to reproduce it more recently than that?

I hit it once a couple of months ago, but I was was busy with much
higher priority stuff at the time (sorting out a CVE-worthy bug fix)
so it slipped off my radar pretty rapidly after I recovered the test
system and kept doing what I needed to do...

So, yeah, the problems are still there, I just don't run my root
filesystems out of space very often. Like I said - maybe once or
twice a year is the typical frequency this happens.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
