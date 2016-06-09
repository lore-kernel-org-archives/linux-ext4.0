From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] dax: Take shared lock in dax_do_io()
Date: Thu, 9 Jun 2016 02:01:07 -0700
Message-ID: <20160609090107.GA16921@infradead.org>
References: <1464992897-34063-1-git-send-email-Waiman.Long@hpe.com>
 <1464992897-34063-2-git-send-email-Waiman.Long@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Waiman Long <Waiman.Long@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464992897-34063-2-git-send-email-Waiman.Long@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Please just take the extra step and move the locking out of dax_do_io
and into the caller.
