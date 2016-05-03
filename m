From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] ext4: Don't release mutex for DAX write
Date: Tue, 3 May 2016 01:43:43 -0700
Message-ID: <20160503084343.GA31363@infradead.org>
References: <1462219138-44089-1-git-send-email-Waiman.Long@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>
To: Waiman Long <Waiman.Long@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462219138-44089-1-git-send-email-Waiman.Long@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

As explained in another thread I really think we need to get DAX
to stop pretending to be direct I/O, which should also take care
of the locking.  The same issue also exists for ext2 and XFS so it
needs to be solved at a higher level.
