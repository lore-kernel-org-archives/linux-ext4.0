From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] ext3 freeze feature
Date: Fri, 8 Feb 2008 09:59:11 -0500
Message-ID: <20080208145911.GA4257@infradead.org>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu> <01cd01c86a40$21d49410$41a8400a@bsd.tnes.nec.co.jp> <20080208132657.GE3120@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, Theodore Tso <tytso@MIT.EDU>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080208132657.GE3120@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 08, 2008 at 08:26:57AM -0500, Andreas Dilger wrote:
> You may as well make the common ioctl the same as the XFS version,
> both by number and parameters, so that applications which already
> understand the XFS ioctl will work on other filesystems.

Yes.  In facy you should be able to lift the implementations of
XFS_IOC_FREEZE and XFS_IOC_THAW to generic code, there's nothing
XFS-specific in there.

