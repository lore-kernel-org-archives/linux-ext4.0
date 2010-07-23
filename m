From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.35-r5 ext3 corruptions
Date: Fri, 23 Jul 2010 06:58:24 -0400
Message-ID: <20100723105824.GA2205@infradead.org>
References: <20100715105745.GI30737@dastard>
 <20100719224512.GD32635@dastard>
 <20100721063222.GW32635@dastard>
 <20100723104313.GA6431@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100723104313.GA6431@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 23, 2010 at 12:43:14PM +0200, Jan Kara wrote:
> changelog below. I'd much rather attribute the metadata corruption to a missing
> barrier option or barrier support in the virtualization stack. But I guess it's
> hard to tell now.

Any recent qemu/kvm stack has perfectly working barrier support.  Xen
is quite broken in that respect, but I hope no one is using that anyway.

But yes, with large write caches ext3 is rather broken due to the lack
of barriers.  Fortunately enough at least the enterprise enable it
anyway these days.
