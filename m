From: Andrew Morton <akpm@linux-foundation.org>
Subject: Fw: Re: 2.6.21-rc3-mm1
Date: Mon, 12 Mar 2007 22:04:26 -0800
Message-ID: <20070312220426.2b1d7aaa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Radoslaw Szkodzinski" <astralstorm@gmail.com>,
	Kalpak Shah <kalpak@clusterfs.com>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60753 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbXCMFFC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Mar 2007 01:05:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Begin forwarded message:

Date: Mon, 12 Mar 2007 19:14:17 +0100
From: "Radoslaw Szkodzinski" <astralstorm@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Theodore T'so" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm1


On 3/8/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> - Re-added the ext4 development tree to the -mm lineup.  It has stuff in
>   it.
>

And broken stuff too :-)
The nanoseconds patch is broken on x86_64 - makes mtimes from the future:
e.g. year 2431. I suspect an endianness issue.
x86 works fine according to my sources.

The files themselves have correct mtimes, as booting previous kernel
or one w/o the nanoseconds patch works fine.
