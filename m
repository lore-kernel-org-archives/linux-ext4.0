From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 4/4] Support discard if at least one underlying device
	supports it
Date: Fri, 2 Jul 2010 21:54:20 +0100
Message-ID: <20100702205420.GM23989@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1007021107420.7296@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1007021119070.7296@hs20-bc2-1.build.redhat.com> <20100702181430.GD26916@redhat.com> <Pine.LNX.4.64.1007021540150.6197@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1007021554550.11102@hs20-bc2-1.build.redhat.com> <20100702204709.GB21915@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	axboe@kernel.dk, dmonakhov@openvz.org
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100702204709.GB21915@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 02, 2010 at 04:47:09PM -0400, Mike Snitzer wrote:

> If a region doesn't support the discard
> DM has no business processing anything related to the discard (barriers
> included).  It is as simple as that.
 
Indeed - if an I/O is going to fail, discover that as early as we can, trying
to avoid the relatively-expensive barrier process whenever we reasonably can.

Alasdair

