From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v2 02/10] vfs: add support for updating access frequency
Date: Thu, 27 Sep 2012 12:19:19 +1000
Message-ID: <20120927021919.GJ15236@dastard>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
 <1348404995-14372-3-git-send-email-zwu.kernel@gmail.com>
 <20120925091739.GB29154@dastard>
 <CAEH94Lg5haGMh0rkiv27tchthhFGk0o-+FAGiJ5zvPTcO8QbwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	cmm@us.ibm.com, tytso@mit.edu, marco.stornelli@gmail.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEH94Lg5haGMh0rkiv27tchthhFGk0o-+FAGiJ5zvPTcO8QbwA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 26, 2012 at 10:53:07AM +0800, Zhi Yong Wu wrote:
> On Tue, Sep 25, 2012 at 5:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sun, Sep 23, 2012 at 08:56:27PM +0800, zwu.kernel@gmail.com wrote:
> > I note that the code will always insert range items of a length
> > RANGE_SIZE. This means you have a fixed object granularity and hence
> > you have no need for a range based search. That is, you could use a
> > radix tree where each entry in the radix tree points directly to the
> > range object similar to how the page cache uses a radix tree for
> > indexing pages. That brings the possibility of lockless range item
> > lookups....
> Great suggestion, but can we temporarily put it in TODO list? because
> it will bring one big code change.

Sure. I just wanted to point out that there are better choices for
indexing fixed size elements than rb-trees and why it might make
sense to use a different type of tree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
