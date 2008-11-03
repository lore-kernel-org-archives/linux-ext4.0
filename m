From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Mon, 3 Nov 2008 13:13:13 -0800
Message-ID: <20081103131313.e9ae2f93.akpm@linux-foundation.org>
References: <4908C951.2000309@redhat.com>
	<20081103184426.GA31894@ajones-laptop.nbttech.com>
	<20081103113318.35b0c266.akpm@linux-foundation.org>
	<20081103201428.GB30565@ajones-laptop.nbttech.com>
	<20081103123750.67c96224.akpm@linux-foundation.org>
	<20081103205854.GC30565@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org, sct@redhat.com,
	linux-kernel@vger.kernel.org
To: Arthur Jones <ajones@riverbed.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752995AbYKCVNh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 16:13:37 -0500
In-Reply-To: <20081103205854.GC30565@ajones-laptop.nbttech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 3 Nov 2008 12:58:54 -0800
Arthur Jones <ajones@riverbed.com> wrote:

> Hi Andrew, ...
> 
> On Mon, Nov 03, 2008 at 12:37:50PM -0800, Andrew Morton wrote:
> > [...]
> > OK.  But still, questions remain.
> > 
> > - should we clear s_dirt if log_wait_commit() didn't work?
> > 
> > - ext3_force_commit() clears s_dirt also
> > 
> > - should ext3_sync_fs() be dropping the ext3_force_commit() return
> >   value on the floor?
> 
> - does ext4 have a similar issue (ext4_sync_fs looks the same)?
> 

I'm sure it does.  Someone(tm) should prepare the ext4 patch once we've
settled on the ext3 patch.
