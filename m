From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: A couple of ext4 crashes with inlinedata/bigalloc
Date: Tue, 8 Apr 2014 19:54:25 +0800
Message-ID: <20140408115425.GA23781@gmail.com>
References: <20140311030604.GK9875@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60041 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbaDHLsd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2014 07:48:33 -0400
Received: by mail-pa0-f44.google.com with SMTP id bj1so929586pad.3
        for <linux-ext4@vger.kernel.org>; Tue, 08 Apr 2014 04:48:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140311030604.GK9875@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 08:06:04PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> A couple of errors to complain about before I send out the e2fsprogs patchbomb.
> :)
> 
> Zheng: I've been running the metadata checksum test with inline_data set.
> flat_dir_test is a stress test which copies /usr/share/doc into a filesystem
> and then "enlarges" the directories by recursively renaming "$foo" to
> "$foo.longer", with the results below.  e2fsck complained that the directories
> involved (4156, 4251) have multiple links to the subdir inode.  I'm not sure
> what this is all about; the only (circumstantial) evidence I have is that it
> goes away if I don't turn on inline_data.

Hi Darrick,

I guess that you were talking about this bug at LSF/MM submmit this
year, right?  Thanks for reporting this bug.  I am trying to take a
closer look at it.  It would be great if you could tell me where I can
find the your test program ('flat_dir_test').

Regards,
                                                - Zheng
