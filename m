From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/3] block: Create sysfs knobs to override FLUSH/FUA
 support flags
Date: Sat, 5 Feb 2011 08:20:18 -0800
Message-ID: <20110205162018.GA22782@kroah.com>
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
 <20110126071626.GI27190@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
	axboe@kernel.dk, tytso@mit.edu, shli@kernel.org, neilb@suse.de,
	adilger.kernel@dilger.ca, jack@suse.cz, snitzer@redhat.com,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110126071626.GI27190@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 25, 2011 at 11:16:26PM -0800, Darrick J. Wong wrote:
> This patch is the first in a series to refactor the barrier= mount options out
> of the filesystem code.  This patch adds sysfs knobs to disable flush and FUA;

If you add sysfs files, you must also add documentation for these files
in Documentation/ABI/.

Please do that in this patch series.

thanks,

greg k-h
