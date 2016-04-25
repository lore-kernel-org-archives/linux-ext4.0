From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/2] ext4: Pass in DIO_SKIP_DIO_COUNT flag if
 inode_dio_begin() called
Date: Mon, 25 Apr 2016 04:48:02 -0700
Message-ID: <20160425114802.GA15856@infradead.org>
References: <1460484775-33359-1-git-send-email-Waiman.Long@hpe.com>
 <1460484775-33359-2-git-send-email-Waiman.Long@hpe.com>
 <20160420205801.GA24609@infradead.org>
 <571918BC.2060007@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Waiman Long <waiman.long@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <571918BC.2060007@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 21, 2016 at 02:15:24PM -0400, Waiman Long wrote:
> On 04/20/2016 04:58 PM, Christoph Hellwig wrote:
> >FYI, none of the Dax code even needs to ever touch the dio_count,
> >as dax I/O can't be asynchronous, and we thus don't need it to protect
> >against truncate.  I'd suggest to remove it and then end_io callback
> >from the DAX code entirely as a start and then move from there.
> 
> Yes, it seems like we may not need to change the dio_count in dax_do_io()
> after all. BTW, what do mean by using end_io callback as a start?

I mean to remove both the i_dio_count manipulation, and the unessecary
end_io callback from dax_do_io.
