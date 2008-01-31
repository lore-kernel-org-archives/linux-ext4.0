From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [RFC] ext3 freeze feature
Date: Thu, 31 Jan 2008 00:53:02 -0800
Message-ID: <200801310053.03056.phillips@phunq.net>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from phunq.net ([64.81.85.152]:36245 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752710AbYAaIxQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2008 03:53:16 -0500
In-Reply-To: <20080125133329.GB8184@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 25 January 2008 05:33, Theodore Tso wrote:
> and then detect the 
> deadlock case where the process holding the file descriptor used to
> freeze the filesystem gets frozen because it attempted to write to the
> filesystem --- at which point it gets some kind of signal (which
> defaults to killing the process), and the filesystem is unfrozen and
> as part of the unfreeze you wake up all of the processes that were put
> to sleep for touching the frozen filesystem.

Hi Ted,

There are a few holes:

  * The process may try to handle the signal and end up blocking on
     the filesystem again.

  * The process might pass the fd to another process by forking or
     fd passing.

  * The process holding the fd might be trying to take a lock held
     by another process that is blocked on the filesystem, and infinite
     variations on that theme.

Remembering the task that did the ioctl might work out better than
remembering the fd.   Or just not try to be so fancy and rely on the
application to take appropriate measures to ensure it will not access
the filesystem, such as memlocking and not execing.

The freezer also needs to run in PF_MEMALLOC mode or similar
unless it can be sure it will not cause pageout to the frozen filesystem
under low memory conditions.

Regards,

Daniel
