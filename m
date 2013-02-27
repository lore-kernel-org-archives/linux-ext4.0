From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Date: Wed, 27 Feb 2013 16:30:13 -0500
Message-ID: <20130227213013.GG14253@thunk.org>
References: <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com>
 <20130227172256.GA236@x4>
 <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
 <20130227174553.GA224@x4>
 <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
 <20130227184912.GA19624@thunk.org>
 <20130227185625.GA224@x4>
 <20130227191923.GA1121@redhat.com>
 <20130227192907.GB14253@thunk.org>
 <87k3pteank.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Jones <davej@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50432 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab3B0Vac (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Feb 2013 16:30:32 -0500
Content-Disposition: inline
In-Reply-To: <87k3pteank.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 28, 2013 at 12:58:55AM +0400, Dmitry Monakhov wrote:
> Indeed. That's why i give-up rotated disks and run xfstest only on SSD
> or brd module 

Note that some problems only show up on slower devices (because then
the race window is wider), and sometimes they only show up on fast
devices.  This is why I've been doing runs on both HDD's and on tmpfs
kvm disk image files.

> Later we can simply run xfstest/fio/fsx on this image.
> I'll prepare new xfstest based on that idea. But the only disadvantage
> is that loop dev has bottleneck, all requests will be serialized on i_mutex.

If the image file is used as a disk file for KVM, that should avoid
the serialization bottleneck of using the loop device.

Regards,

						- Ted
