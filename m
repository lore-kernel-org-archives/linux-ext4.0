From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Oops, incorrect tag: v1.40.5 in e2fsprogs git repository
Date: Mon, 28 Jan 2008 19:55:08 -0500
Message-ID: <20080129005508.GB6774@mit.edu>
References: <20080128181923.GB24206@mit.edu> <20080129004331.GB14100@machine.or.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Petr Baudis <pasky@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52735 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759297AbYA2AzT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 19:55:19 -0500
Content-Disposition: inline
In-Reply-To: <20080129004331.GB14100@machine.or.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 29, 2008 at 01:43:31AM +0100, Petr Baudis wrote:
>   Done, though it should be doable from your side as well by something
> like
> 	git push reporepo :refs/tags/v1.40.5
> 

Wow, I thought that only worked on branches, but you're right, that
works.  Thanks!!!

						- Ted
