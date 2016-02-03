From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] ext4: add a line break for proc mb_groups display
Date: Wed, 03 Feb 2016 13:17:54 -0800
Message-ID: <1454534274.7291.128.camel@perches.com>
References: <1454505546-4875-1-git-send-email-huaitong.han@intel.com>
	 <20160203181356.GA5842@birch.djwong.org>
	 <1454524232.7291.105.camel@perches.com>
	 <20160203193233.GB5842@birch.djwong.org>
	 <1454528313.7291.115.camel@perches.com>
	 <20160203200706.GG22352@birch.djwong.org>
	 <41C709B0-476E-4DE8-B973-1F7237102708@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Huaitong Han <huaitong.han@intel.com>, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <41C709B0-476E-4DE8-B973-1F7237102708@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2016-02-03 at 14:12 -0700, Andreas Dilger wrote:

> I think it makes sense to accept the patch, since I doubt any scripts
> will be broken, and it is the "right thing to do" rather than
> perpetuate a bug.

Perhaps it also would make sense to add some text
to the commit log about this.
