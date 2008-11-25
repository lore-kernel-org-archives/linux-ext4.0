From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: rm: cannot remove `???': No such file or directory
Date: Tue, 25 Nov 2008 01:35:58 -0500
Message-ID: <20081125063558.GG20928@mit.edu>
References: <492AB6C5.1050609@cerberis.soften.ktu.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Arturas K <arturas@cerberis.soften.ktu.lt>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58423 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbYKYGgH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2008 01:36:07 -0500
Content-Disposition: inline
In-Reply-To: <492AB6C5.1050609@cerberis.soften.ktu.lt>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 24, 2008 at 04:14:29PM +0200, Arturas K wrote:
> hello,
>
> I did a simple/dirty benchmark on multiple file systems, and ext4dev  
> encounters some problems recursively removing linux tree... tested with  
> default and multiple altered option sets of mkfs.ext4dev and/or mount  
> options - the same story :(

What kernel version were you using?

							- Ted
