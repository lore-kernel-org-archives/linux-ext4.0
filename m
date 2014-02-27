From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] util-linux/fallocate: introduce an option -c to support
 FALLOC_FL_COLLAPSE_RANGE
Date: Thu, 27 Feb 2014 10:00:05 +0100
Message-ID: <20140227090005.GH32036@x2.net.home>
References: <alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
 <1393355305-12009-1-git-send-email-dongsu.park@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org, tytso@mit.edu,
	Lukas Czerner <lczerner@redhat.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Dongsu Park <dongsu.park@profitbricks.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1393355305-12009-1-git-send-email-dongsu.park@profitbricks.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 25, 2014 at 08:08:25PM +0100, Dongsu Park wrote:
> Introduce a new option -c (or --collapse-range) to support a new flag
> FALLOC_FL_COLLAPSE_RANGE for fallocate(2). It will nullify a particular
> range [offset, offset+len] by shifting extents beyond the range to the
> beginning of the hole.
 
 Thanks!

> To test that, it's necessary to apply kernel patches in the patchset
 
 We (util-linux) always waiting for new stuff in Linus tree :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
