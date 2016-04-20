From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/2] ext4: Pass in DIO_SKIP_DIO_COUNT flag if
 inode_dio_begin() called
Date: Wed, 20 Apr 2016 13:58:01 -0700
Message-ID: <20160420205801.GA24609@infradead.org>
References: <1460484775-33359-1-git-send-email-Waiman.Long@hpe.com>
 <1460484775-33359-2-git-send-email-Waiman.Long@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Waiman Long <Waiman.Long@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460484775-33359-2-git-send-email-Waiman.Long@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

FYI, none of the Dax code even needs to ever touch the dio_count,
as dax I/O can't be asynchronous, and we thus don't need it to protect
against truncate.  I'd suggest to remove it and then end_io callback
from the DAX code entirely as a start and then move from there.
