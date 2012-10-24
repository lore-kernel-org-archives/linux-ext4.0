From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: OOPS after deleting file on ext4 filesystem
Date: Tue, 23 Oct 2012 23:08:12 -0400
Message-ID: <20121024030812.GA21714@thunk.org>
References: <20121024005022.GA25399@elliptictech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Nick Bowler <nbowler@elliptictech.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57151 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934056Ab2JXDIQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Oct 2012 23:08:16 -0400
Content-Disposition: inline
In-Reply-To: <20121024005022.GA25399@elliptictech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 23, 2012 at 08:50:22PM -0400, Nick Bowler wrote:
> Hi folks,
> 
> I just saw an ext4 oops on one of my machines after a couple months of
> uptime, on Linux 3.5.2.  I doubt I will be able to reproduce the problem
> easily so I'm just posting this in case anyone can tell what's going on.

Fixed in v3.5.3 or later kernels.  (Commit 2cd45bebc56a)

      	 	   	 	   - Ted
