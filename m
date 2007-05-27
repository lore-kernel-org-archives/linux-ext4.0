From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext4 and creation time
Date: Sun, 27 May 2007 10:25:53 -0600
Message-ID: <20070527162553.GI5181@schatzie.adilger.int>
References: <Pine.LNX.4.64.0705102134030.3570@lancer.cnet.absolutedigital.net> <1180089677.27539.4.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Cal Peake <cp@absolutedigital.net>, Theodore Tso <tytso@mit.edu>,
	extfs Mailing List <linux-ext4@vger.kernel.org>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:46672 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbXE0QZz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 May 2007 12:25:55 -0400
Content-Disposition: inline
In-Reply-To: <1180089677.27539.4.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 25, 2007  16:11 +0530, Kalpak Shah wrote:
> On Fri, 2007-05-25 at 06:13 -0400, Cal Peake wrote:
> > I found this had already been brought up in the past but couldn't find if 
> > a definitive decision was made.
> > 
> > Will ext4 include a creation time field?
> 
> Yes, the creation time field will be in ext4. It has already been
> included in Ted's e2fsprogs tree and will be included in the kernel when
> the nanosecond patch is sent upstream.

As a caveat, there is not yet any API to access this.  One possibility is
to add a virtual extended attribute like user.crtime that returns a
struct timespec or similar.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
