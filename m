From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: hand over jobs handling discard commands on commit
 complete phase to kworkers
Date: Tue, 16 May 2017 04:53:06 -0700
Message-ID: <20170516115306.GA15058@infradead.org>
References: <CGME20170516073738epcas1p42daa31d04ae9d07eae07d9fcee6708a2@epcas1p4.samsung.com>
 <1494920262-10128-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.com, tytso@mit.edu, linux-ext4@vger.kernel.org,
        linux-block@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1494920262-10128-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 16, 2017 at 04:37:42PM +0900, Daeho Jeong wrote:
> Now, when we mount ext4 filesystem with '-o discard' option, we have to
> issue all the discard commands for the blocks to be deallocated and
> wait for the completion of the commands on the commit complete phase.

No, you don't.  You can execute them asynchronously, similar to what
XFS already does.
