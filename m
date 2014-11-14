From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests and ext4
Date: Fri, 14 Nov 2014 11:02:16 +1100
Message-ID: <20141114000216.GN28565@dastard>
References: <CAH2r5murzVmOVnRchq=U-jx74U96g7N6Y42CW0iX4HKpWnbmxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	fstests@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:12703 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933846AbaKNAC6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2014 19:02:58 -0500
Content-Disposition: inline
In-Reply-To: <CAH2r5murzVmOVnRchq=U-jx74U96g7N6Y42CW0iX4HKpWnbmxw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2014 at 05:38:53PM -0600, Steve French wrote:
> To get xfstests to build on Ubuntu 14.10 and run (after adding various
> packages I could get all but 11 of the tests to build and run) I had
> to install the following packages:
> 
> sudo apt-get install xfslibs-dev uuid-dev libtool e2fsprogs automake
> libuuid1 libuuidm-ocaml-dev attr libattr1-dev libacl1-dev libaio-dev
> xfsprogs libgdbm-dev gawk fio dbench

Documentation patch for the README file?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
