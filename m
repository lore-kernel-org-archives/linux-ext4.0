From: tytso@mit.edu
Subject: Re: [PATCH 1/2] fs-writeback: Add helper function to start
 writeback   if idle
Date: Wed, 23 Dec 2009 08:00:42 -0500
Message-ID: <20091223130042.GF21594@thunk.org>
References: <4B22D029.5090304@redhat.com>
 <20091218114427.GQ4489@kernel.dk>
 <4B2B9FF5.4030102@redhat.com>
 <20091218153336.GR4489@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091218153336.GR4489@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 18, 2009 at 04:33:36PM +0100, Jens Axboe wrote:
> > Doesn't matter to me really; maybe it'd be simpler if it all went
> > though the ext4 tree so that there aren't any ordering problems?
> 
> Definately :-)

Thanks, I've added them to the ext4 patch queue.
