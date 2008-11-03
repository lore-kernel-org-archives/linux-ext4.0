From: Arthur Jones <ajones@riverbed.com>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Mon, 3 Nov 2008 12:58:54 -0800
Message-ID: <20081103205854.GC30565@ajones-laptop.nbttech.com>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081103123750.67c96224.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "sandeen@redhat.com" <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.riverbed.com ([206.169.144.7]:29352 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbYKCU6z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 15:58:55 -0500
Content-Disposition: inline
In-Reply-To: <20081103123750.67c96224.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrew, ...

On Mon, Nov 03, 2008 at 12:37:50PM -0800, Andrew Morton wrote:
> [...]
> OK.  But still, questions remain.
> 
> - should we clear s_dirt if log_wait_commit() didn't work?
> 
> - ext3_force_commit() clears s_dirt also
> 
> - should ext3_sync_fs() be dropping the ext3_force_commit() return
>   value on the floor?

- does ext4 have a similar issue (ext4_sync_fs looks the same)?

Arthur
