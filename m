From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] [PATCH 2/2] direct-io: handle handle O_(D)SYNC AIO
Date: Tue, 27 Nov 2012 19:30:27 -0500
Message-ID: <20121128003027.GA14500@infradead.org>
References: <20121123075502.307482760@bombadil.infradead.org>
 <20121123075916.375908616@bombadil.infradead.org>
 <x49a9u3f276.fsf@segfault.boston.devel.redhat.com>
 <20121128002656.GC4321@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121128002656.GC4321@blackbox.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 27, 2012 at 04:26:56PM -0800, Darrick J. Wong wrote:
> cc'ing the ext4 list, since this affects ext4 pretty heavily.

Oops, I really should have done that for the full series.
