From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1038/1285] Replace numeric parameter like 0444 with macro
Date: Tue, 2 Aug 2016 17:17:02 -0400
Message-ID: <20160802211702.GA11745@thunk.org>
References: <20160802121047.19315-1-baolex.ni@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, david.vrabel@citrix.com,
	tomi.valkeinen@ti.com, m.chehab@samsung.com,
	gregkh@linuxfoundation.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	chuansheng.liu@intel.com, mhalcrow@google.com,
	kirill.shutemov@linux.intel.com, oneukum@suse.com
To: Baole Ni <baolex.ni@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160802121047.19315-1-baolex.ni@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 02, 2016 at 08:10:47PM +0800, Baole Ni wrote:
> I find that the developers often just specified the numeric value
> when calling a macro which is defined with a parameter for access permission.
> As we know, these numeric value for access permission have had the corresponding macro,
> and that using macro can improve the robustness and readability of the code,
> thus, I suggest replacing the numeric parameter with the macro.

I actually find using the macros significantly **decrease* the
readiability of the code.  A quick glance at 0644 quickly tells you
what the permissions are.  Parsing S_IRUSR | S_IRGRP | S_IROTH takes
longer, and is more error prone.

NACK.

					- Ted
