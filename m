From: Arthur Jones <ajones@riverbed.com>
Subject: Re: ext3: slow symlink corruption on umount...
Date: Thu, 30 Oct 2008 11:32:24 -0700
Message-ID: <20081030183224.GB8333@ajones-laptop.nbttech.com>
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081027165423.GB25797@ajones-laptop.nbttech.com> <20081029195403.GA8333@ajones-laptop.nbttech.com> <4908C951.2000309@redhat.com> <20081030174057.GB7926@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758923AbYJ3Scj@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081030174057.GB7926@ajones-laptop.nbttech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Eric, ...

On Thu, Oct 30, 2008 at 10:40:57AM -0700, Arthur Jones wrote:
> [...]
> return 2 at the top of write_cache_pages().  In the working
> case, bdi_write_congested() returns 0 and the inodes are
> found twice in the s_io list in generic_sync_sb_inodes,
> first as i_state==7, where they are skipped, then a second
> time as i_state==4, where ->writepage() is then called...

To clarify, they are not on the list twice, rather
a separate call to generic_sync_sb_inodes sees them
again as i_state==4...

Arthur
