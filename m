From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: imperfect FIEMAP results on btrfs
Date: Fri, 03 May 2013 08:57:11 +0300
Message-ID: <1367560631.23415.2.camel@sauron.fi.intel.com>
References: <1367510414.32396.90.camel@sauron.fi.intel.com>
	 <20130502233103.GA15549@dastard>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20130502233103.GA15549@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2013-05-03 at 09:31 +1000, Dave Chinner wrote:
> IOWs, you simply can't assume that a specific test will give you the
> same block layout across filesystems and different filesystem
> configurations. Welcome to the world of "can't assume anything about
> block layout" pain xfstests has been dealing with for years ;)

This is what I also assumed, but wanted to get some feed-back from the
community. Thanks a lot for the answer!

-- 
Best Regards,
Artem Bityutskiy

