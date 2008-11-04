From: Arthur Jones <ajones@riverbed.com>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Tue, 4 Nov 2008 08:26:08 -0800
Message-ID: <20081104162608.GD3371@ajones-laptop.nbttech.com>
References: <20081103123750.67c96224.akpm@linux-foundation.org> <20081103205854.GC30565@ajones-laptop.nbttech.com> <20081103131313.e9ae2f93.akpm@linux-foundation.org> <20081103211929.GA18117@mit.edu> <20081103132735.9e63a3d0.akpm@linux-foundation.org> <20081103220144.GD18117@mit.edu> <20081103142706.92e3a2ae.akpm@linux-foundation.org> <20081103225544.GH18117@mit.edu> <20081103230104.GC3371@ajones-laptop.nbttech.com> <20081103231209.GA29964@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, sct@redhat.com,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.riverbed.com ([206.169.144.12]:31816 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbYKDQ0J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 11:26:09 -0500
Content-Disposition: inline
In-Reply-To: <20081103231209.GA29964@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, ...

On Mon, Nov 03, 2008 at 03:12:09PM -0800, Theodore Tso wrote:
> [...]
> BTW, did you ever open a bugzilla entry for this the symlink
> corruption problem that we should reference in the commit log?

Nope...

Patch looks good now -- thanks for looking into this...

Arthur
