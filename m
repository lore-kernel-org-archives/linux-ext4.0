From: Chris Mason <chris.mason@oracle.com>
Subject: Re: ext3 default journal mode
Date: Mon, 20 Jul 2009 10:18:53 -0400
Message-ID: <20090720141853.GE25193@think>
References: <4A63DB89.2060306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>,
	"Stephen C. Tweedie" <sct@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	Josef Bacik <jbacik@redhat.com>, Mingming Cao <cmm@us.ibm.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:32002 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZGTOTz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jul 2009 10:19:55 -0400
Content-Disposition: inline
In-Reply-To: <4A63DB89.2060306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 19, 2009 at 10:50:49PM -0400, Ric Wheeler wrote:
>
> Now that we have put some some distance between us and the mega-thread, I 
> think that it is time to put some sanity back into the ext3 journal mode 
> options.
>
> My preference is to revert the default back to ordered mode or (if Chris 
> is ready) back to guarded mode.

My plan was to get guarded into .30, but that clearly didn't happen.
So, I'll resend this week and try to have it ready for .31, unless
people would rather avoid the changes to the tried and true ext3.

-chris
