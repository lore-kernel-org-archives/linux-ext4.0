From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [patch 1/2] e2fsprogs: user selectable dup block handling in fsck
Date: Wed, 31 Jan 2007 23:06:24 -0700
Message-ID: <20070201060624.GT5404@schatzie.adilger.int>
References: <Pine.LNX.4.61.0701310737550.25489@webb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jim Garlick <garlick@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:47823 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161216AbXBAGG0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Feb 2007 01:06:26 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0701310737550.25489@webb>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jan 31, 2007  08:22 -0800, Jim Garlick wrote:
> It also adds a check to make sure only one -E option is passed
> on the command line as -E option parsing is not cumulative.
>
> @@ -633,6 +639,8 @@ static errcode_t PRS(int argc, char *arg
>  		case 'E':
> +			if (extended_opts)
> +				fatal_error(ctx, _("-E must only be 
> specified once"));
>  			extended_opts = optarg;

In such cases I've usually just changed the code to do the parsing
as the option is passed.  Otherwise, it isn't possible to "override"
previously-specified options. This sometimes is needed if you have an
alias or script that is passing a bunch of options, and in some rare
cases you don't want the default, e.g.

alias mye2fsck="e2fsck -f -p -E clone=dup"

# mye2fsck -y -E clone=zero /dev/really-broken

Ted, is there a reason that the call to parse_extended_opts() can't
just be moved in place of saving the options in extended_opts?  I
can't see anything in -E (yet) that depends on other options that
might not be set yet.

Also, it looks like that function leaks the duplicated string in "buf",
since that variable goes out of scope without freeing the allocation.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
