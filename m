From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 3/3] ext4: add tracepoint in punching hole
Date: Fri, 18 Jan 2013 10:28:08 +0800
Message-ID: <20130118022808.GB2804@gmail.com>
References: <1345695941-15053-1-git-send-email-wenqing.lz@taobao.com>
 <1345695941-15053-4-git-send-email-wenqing.lz@taobao.com>
 <20130117033822.GA12191@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130117033822.GA12191@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 16, 2013 at 10:38:22PM -0500, Theodore Ts'o wrote:
> On Thu, Aug 23, 2012 at 12:25:41PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > This patch adds a tracepoint in ext4_punch_hole.
> > 
> > CC: Lukas Czerner <lczerner@redhat.com>
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> 
> I'm still waiting for the next version of the indirect punch patches
> (which you said you'd work on after the extent status patches, given
> that I had noted other xfstest failures that were apparently caused by
> these patches), but in the mean time, adding a tracepoint for
> ext4_punch_hole() seem like it would make sense, so I've applied this
> patch to the ext4 tree.

Oops, my apology.  I forgot to CC' patches [1] to you.  It is my fault.
This patch should be fine because there is no any changes.  I will
rebase the others against 3.8-rc3, and run xfstest to make sure that it
is OK.  Later I will resend them to the mailling list.

1. http://comments.gmane.org/gmane.comp.file-systems.ext4/35491

Thanks,
                                                - Zheng
