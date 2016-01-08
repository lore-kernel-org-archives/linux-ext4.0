From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 00/35 v2] separate operations from flags in the bio/request
 structs
Date: Fri, 08 Jan 2016 14:50:58 -0600
Message-ID: <56902132.8080008@cs.wisc.edu>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com> <20160108133237.GA7663@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	konrad.wilk@oracle.com, drbd-dev@lists.linbit.com,
	philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
	linux-raid@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
	target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
To: Christoph Hellwig <hch@infradead.org>, mchristi@redhat.com
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20160108133237.GA7663@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 01/08/2016 07:32 AM, Christoph Hellwig wrote:
> This looks good to me from a highlevel point of view.
> Do you also have a git tree to take a look at all the changes in a
> single big diff?

I uploaded a git tree here:

https://github.com/mikechristie/linux-kernel.git

based off of linux-next today. The patches are just in the master branch.
