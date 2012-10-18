From: Jan Kara <jack@suse.cz>
Subject: Re: Local DoS through write heavy I/O on CFQ & Deadline
Date: Fri, 19 Oct 2012 00:24:49 +0200
Message-ID: <20121018222449.GA19204@quack.suse.cz>
References: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk>
 <20121012133044.GA10115@dhcp22.suse.cz>
 <E6EF14955C67D6CA58918872@nimrod.local>
 <20121012145838.GD22083@dhcp22.suse.cz>
 <3D1C85A52BB960B79E37AC30@nimrod.local>
 <20121018212845.GB17646@quack.suse.cz>
 <50807F26.5070106@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Alex Bligh <alex@alex.org.uk>,
	Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Chris Friesen <chris.friesen@genband.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab2JRWYw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2012 18:24:52 -0400
Content-Disposition: inline
In-Reply-To: <50807F26.5070106@genband.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 18-10-12 16:13:58, Chris Friesen wrote:
> On 10/18/2012 03:28 PM, Jan Kara wrote:
> 
> >   Yeah, ionice has its limitations. The problem is that all buffered
> >writes happen just into memory (so completely independently of ionice
> >settings). Subsequent writing of dirty memory to disk happens using flusher
> >thread which is a kernel process and it doesn't know anything about IO
> >priority set for task which created the file. If you wrote the file with
> >oflag=direct or oflag=sync you would see that ionice works as expected.
> 
> Has anyone looked at storing the ionice value with the buffered
> write request such that the actual writes to disk could be sorted by
> priority and done with the ionice level of the original caller?
  There's nothing as "buffered write request" in kernel. When buffered
write happens, data are just copied into page cache. We could attach a tag
to each modified page in the page cache but that would get really expensive.

Essentially the same problems happens with cgroups where buffered writes
are not accounted as well. There we considered to attach a tag to inodes
(which doesn't work well if processes from different cgroups / with
different IO priority write to the same inode but that's not that common)
which is reasonably cheap. But then you have to build smarts into flusher
thread to prioritize inodes according to tags (you cannot really let
flusher thread just submit IO with that priority because when it gets
blocked, it starves writeback with possible higher priority). Alternatively
you could have separate flusher thread per-cgroup / IO priority. That is
easier from code point of view but throughput suffers because of limited
merging of IO. So all in all the problem is known but hard to tackle.

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
