From: Christoph Hellwig <hch@lst.de>
Subject: Re: lseek SEEK_HOLE / SEEK_DATA fixes and switch to iomap V3.2-hch
Date: Thu, 29 Jun 2017 20:53:20 +0200
Message-ID: <20170629185320.GA31467@lst.de>
References: <20170629135420.21357-1-hch@lst.de> <20170629184751.GH5874@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170629184751.GH5874@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 29, 2017 at 11:47:51AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 29, 2017 at 06:54:15AM -0700, Christoph Hellwig wrote:
> > Here is my take on all the current seek work.  It has my XFS quota changes
> 
> I think the quota change patch fell out of this series, but I can grab
> it from the previous iteration if it hasn't changed.

It hasn't, please do.
