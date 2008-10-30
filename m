From: Arthur Jones <ajones@riverbed.com>
Subject: Re: ext3: slow symlink corruption on umount...
Date: Thu, 30 Oct 2008 10:40:57 -0700
Message-ID: <20081030174057.GB7926@ajones-laptop.nbttech.com>
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081027165423.GB25797@ajones-laptop.nbttech.com> <20081029195403.GA8333@ajones-laptop.nbttech.com> <4908C951.2000309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.riverbed.com ([206.169.144.12]:36607 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbYJ3Rk6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Oct 2008 13:40:58 -0400
Content-Disposition: inline
In-Reply-To: <4908C951.2000309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric, ...

On Wed, Oct 29, 2008 at 01:36:33PM -0700, Eric Sandeen wrote:
> [...]
> I'll look into it ...

In the cases that fail, I'm seeing bdi_write_congested()
return 2 at the top of write_cache_pages().  In the working
case, bdi_write_congested() returns 0 and the inodes are
found twice in the s_io list in generic_sync_sb_inodes,
first as i_state==7, where they are skipped, then a second
time as i_state==4, where ->writepage() is then called...

Arthur
