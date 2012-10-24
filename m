From: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: OOPS after deleting file on ext4 filesystem
Date: Wed, 24 Oct 2012 09:04:36 -0400
Message-ID: <20121024130436.GA28400@elliptictech.com>
References: <20121024005022.GA25399@elliptictech.com>
 <20121024030812.GA21714@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.scalarmail.ca ([98.158.95.75]:13132 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab2JXNEj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2012 09:04:39 -0400
Content-Disposition: inline
In-Reply-To: <20121024030812.GA21714@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-10-23 23:08 -0400, Theodore Ts'o wrote:
> On Tue, Oct 23, 2012 at 08:50:22PM -0400, Nick Bowler wrote:
> > I just saw an ext4 oops on one of my machines after a couple months of
> > uptime, on Linux 3.5.2.  I doubt I will be able to reproduce the problem
> > easily so I'm just posting this in case anyone can tell what's going on.
> 
> Fixed in v3.5.3 or later kernels.  (Commit 2cd45bebc56a)

Good to know.

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
