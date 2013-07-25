From: Zach Brown <zab@redhat.com>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Thu, 25 Jul 2013 13:09:39 -0700
Message-ID: <20130725200939.GH26554@lenny.home.zabbo.net>
References: <1374699833.7083.2.camel@localhost>
 <20130724233628.GD3641@logfs.org>
 <51F14136.30409@mozilla.com>
 <20130725180545.GB15590@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dhaval Giani <dgiani@mozilla.com>, linux-kernel@vger.kernel.org,
	tytso@mit.edu, tglek@mozilla.com, vdjeric@mozilla.com,
	glandium@mozilla.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756465Ab3GYUJp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jul 2013 16:09:45 -0400
Content-Disposition: inline
In-Reply-To: <20130725180545.GB15590@logfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > What about introducing a new flag, O_COMPR which tells the
> > kernel, btw, we want this file to be decompressed if it can be. It
> > can fallback to O_RDONLY or something like that? That gets rid of
> > the chattr ugliness.
> 
> How is that different from chattr ugliness, which also comes down to a
> single flag? ;)

It's much worse because it's per fd instead of per inode.

The page cache, where the undisclosed complexity of this proposal lurks,
where compressed and uncompressed cached copies of the data need to be
managed somehow, is per inode.

- z
(Hi Taras! :))
