From: Fabian Frederick <fabf@skynet.be>
Subject: Re: [PATCH 1/1] ext2: Add __init macro to init_inodecache
Date: Sat, 1 Feb 2014 18:19:39 +0800
Message-ID: <20140201181939.c38e6f99592e08bd46e30c5c@skynet.be>
References: <20140201160202.a3ac96c613754013300b462d@skynet.be>
	<20140201175334.GJ20939@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:39539 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933256AbaBASS0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Feb 2014 13:18:26 -0500
In-Reply-To: <20140201175334.GJ20939@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 1 Feb 2014 10:53:34 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Sat, Feb 01, 2014 at 04:02:02PM +0800, Fabian Frederick wrote:
> > init_inodecache is only called by __init init_ext2_fs.
> 
> Looks like this is true for the majority of filesystems.  Would you care
> to submit more patches?  :-)
No problem ! Is it better to send separate patches like this one or one patch for all filesystems ?

> 
> -- 
> Matthew Wilcox				Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
