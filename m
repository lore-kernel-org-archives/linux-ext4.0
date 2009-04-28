From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH RFC] ext3 data=guarded v5
Date: Tue, 28 Apr 2009 14:54:14 -0400
Message-ID: <1240944854.15136.46.camel@think.oraclecorp.com>
References: <1240941840.15136.44.camel@think.oraclecorp.com>
	 <1240943582.5611.15.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Mike Galbraith <efault@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:56274 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZD1Sz3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 14:55:29 -0400
In-Reply-To: <1240943582.5611.15.camel@marge.simson.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-04-28 at 20:33 +0200, Mike Galbraith wrote:
> On Tue, 2009-04-28 at 14:04 -0400, Chris Mason wrote:
> 
> > This patch adds the delayed i_size update to ext3, along with a new
> > mount option (data=guarded) to enable it.
> 
> Is there a good reason to require a new mount option for this vs just
> calling it a fix (or enhancement) to the existing writeback option?
> 
> I presume yes (you are fs guy..), but wonder what that reason is.

It is mostly cutting down on the risk of the patch.  The patch tries to
isolate its changes to just data=guarded mode, so you can go back to the
old and crusty modes if things go badly.

-chris


