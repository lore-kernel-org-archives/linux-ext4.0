From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Fri, 19 Jul 2013 09:03:15 +0800
Message-ID: <20130719010315.GB21615@gmail.com>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
 <51E8356C.9030603@redhat.com>
 <20130718235451.GA29997@gmail.com>
 <20130719000738.GD17938@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62121 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759363Ab3GSAoX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Jul 2013 20:44:23 -0400
Received: by mail-pa0-f53.google.com with SMTP id tj12so3804429pac.26
        for <linux-ext4@vger.kernel.org>; Thu, 18 Jul 2013 17:44:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130719000738.GD17938@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 18, 2013 at 08:07:38PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 19, 2013 at 07:54:51AM +0800, Zheng Liu wrote:
> > 
> > I have talked with my colleague who is a MySQL contributor about whether
> > MySQL tries to preallocate some files or not.  As far as I know, at
> > least MySQL doesn't try to do it until now.  I don't have the source
> > code of Oracle or DB2, these giant databases might use preallocation I
> > guess.
> 
> Oracle and DB2 don't use preallocate, because they don't want the
> metadata update overhead.  So for software packages that are really
> critically worried about 99percentile latency, they will generally
> either pre-zero the file ahead of time, so all of the extents are
> written.  Or, they will use the out-of-tree nohidestale patch, and
> mark all of the extents as written.  (If you are doing A/B benchmark
> comparisons, using nohidestale means the setup overhead for each
> benchmark run can be measured in minutes instead of hours...)
> 
> On at least one of the enterprise databases which I'm familiar with,
> they don't pre-zero the entire database file, but they'll do it in
> chunks of N megabytes.  That means they don't have the huge time lag
> when the database is initially created, but then every so often, when
> the database will suddenly use most of the disk bandwidth to zero the
> next chunk of 16 or 32 or 64 megabytes.  (This tends to do a real
> number on your 99.9 percentile latency numbers, if you care about such
> things....)

Thanks for correcting me. :-). Yes, MySQL does like this.  But the
difference between them is that MySQL doesn't try to zero any chunks
directly.  It just writes out the dirty pages (Yes, in MySQL it has its
own buffer pool and manages it by itself, and it is also called page.),
such as 16 or 32 megabytes, if I understand correctly.  So, in general,
it always wins if we keep the metadata of ext4 file system in memory, at
least for database application.

                                                - Zheng
