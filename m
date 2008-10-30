From: Arthur Jones <ajones@riverbed.com>
Subject: Re: ext3: slow symlink corruption on umount...
Date: Thu, 30 Oct 2008 14:34:00 -0700
Message-ID: <20081030213400.GA28900@ajones-laptop.nbttech.com>
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081027165423.GB25797@ajones-laptop.nbttech.com> <20081029195403.GA8333@ajones-laptop.nbttech.com> <4908C951.2000309@redhat.com> <20081030174057.GB7926@ajones-laptop.nbttech.com> <4909F705.8090904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.riverbed.com ([206.169.144.7]:10710 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYJ3VeR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Oct 2008 17:34:17 -0400
Content-Disposition: inline
In-Reply-To: <4909F705.8090904@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,  ...

On Thu, Oct 30, 2008 at 11:03:49AM -0700, Eric Sandeen wrote:
> [...]
> Something is definitely racy here; in my simple testcase I get failures
> maybe 30-50% of the time...

Some more info: in the working case, the inodes are put
back on sb->s_dirty at then next ext3_sync_fs() call:

__fsync_super -> DQUOT_SYNC -> ext3_sync_fs -> log_wait_commit

In the failing case, journal_start_commit returns 0 in ext_sync_fs
and the inodes disappear into never-never land...

Arthur
