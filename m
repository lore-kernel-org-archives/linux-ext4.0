From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: mmc filesystem performance decreased on the first write after
 filesystem creation
Date: Wed, 30 May 2018 12:15:07 -0400
Message-ID: <20180530161507.GA14279@thunk.org>
References: <a976e20a-3ed1-43d0-4665-f570ef496d02@ti.com>
 <20180528062618.GA4196@lst.de>
 <c6a47e30-f07d-3f79-2189-38b6f01429b9@intel.com>
 <43d4164f-5dda-b49a-6008-1f5bf4b08547@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, Faiz Abbas <faiz_abbas@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, linux-ext4@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43d4164f-5dda-b49a-6008-1f5bf4b08547@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 30, 2018 at 11:51:41AM +0300, Adrian Hunter wrote:
> 
> And discards are not enabled by default by mount so, at least on ext4,
> adding "-o discard" is needed in the mount options.

This is because doing discards right away is not always a win from
performance reasons.  There are some flash devices where discards are
super-slow and some devices where issuing discards too quickly would
cause them to trigger internal FTL race conditions and turn them into
paperweights.

There was at least one engineer from a Linux distribution who argued
for making discard not the default because back then, there were a lot
of SSD's floating out there (by a manufacturer who thankfully has
since gone bankrupt :-) for which they didn't want to deal with the
support requests from people who were angry about lost data or
destroyed SSD's --- because guess who they would blame?

Also, please note that for many devices it's much better to
periodically run fstrim (once a day or once a week) out of cron.

If someone wants to do a survey of available hardware and demonstrate:

   * there is significant value from enabling -o discard by default
     (instead of using fstrim)

   * there are no (or at least very, very few) devices for which
     enabling -o discard results in a major performance regression,
     and

   * if there are any devices left that turn into paperweights, they can
     be managed using blacklists,

I'm certainly open to changing the default.  There was, however, a
really good *reason* why the default was chosen to be the way it is.

					- Ted
