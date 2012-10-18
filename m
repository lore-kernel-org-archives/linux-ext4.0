From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC v3 09/13] vfs: add one wq to update map info periodically
Date: Thu, 18 Oct 2012 10:25:30 +0800
Message-ID: <20121018022530.GB24939@gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
 <1349863655-29320-10-git-send-email-zwu.kernel@gmail.com>
 <20121016002744.GC2864@dastard>
 <CAEH94LjoanfL3piP89qM6MP6zdN0AybfeqJe0kR_5-DJ0mLH_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, dave@jikos.cz, tytso@mit.edu,
	cmm@us.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48823 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2JRCO2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Oct 2012 22:14:28 -0400
Content-Disposition: inline
In-Reply-To: <CAEH94LjoanfL3piP89qM6MP6zdN0AybfeqJe0kR_5-DJ0mLH_w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 17, 2012 at 02:34:15PM +0800, Zhi Yong Wu wrote:
> >> diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
> >> index d19e64a..7a79a6d 100644
> >> --- a/fs/hot_tracking.h
> >> +++ b/fs/hot_tracking.h
> >> @@ -36,6 +36,9 @@
> >>   */
> >>  #define TIME_TO_KICK 400
> >>
> >> +/* set how often to update temperatures (seconds) */
> >> +#define HEAT_UPDATE_DELAY 400
> >
> > FWIW, 400 seconds is an unusual time period. It's expected that
> > periodic work might take place at intervals of 5 minutes, 10
> > minutes, etc, not 6m40s. It's much easier to predict and understand
> > behaviour if it's at a interval of whole units like minutes,
> > especially when looking at timestamped event traces. Hence 300s (5
> > minutes) makes a lot more sense as a period for updates...
> got it. thanks.

Hi Zhi Yong,

IMHO we'd better to make this value parameterized, and then the user
can adjust this value dynamically.

Regards,
Zheng
