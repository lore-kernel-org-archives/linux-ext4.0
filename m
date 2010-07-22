From: Ted Ts'o <tytso@mit.edu>
Subject: Re: openvz: Oops in ext4 when VPS starts
Date: Thu, 22 Jul 2010 11:01:45 -0400
Message-ID: <20100722150145.GE14882@thunk.org>
References: <AANLkTilaycSLL2dDnXDVs1gCiD0B8K78i2rBdWJGZrRD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, devel@openvz.org,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Drunkard Zhang <gongfan193@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45470 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab0GVPBu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jul 2010 11:01:50 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTilaycSLL2dDnXDVs1gCiD0B8K78i2rBdWJGZrRD@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 22, 2010 at 05:39:16PM +0800, Drunkard Zhang wrote:
> I run into a oops when mirgate /vz directory to ext4 lvm under gentoo + openvz.

What were you doing precisely at the time of the oops?  The oops logs
indicates it was a cp, but a cp of what?  And is this somethign you
can easily reproduce?

					- Ted
