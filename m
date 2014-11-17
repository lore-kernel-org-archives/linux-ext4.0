From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests and ext4
Date: Tue, 18 Nov 2014 07:38:04 +1100
Message-ID: <20141117203804.GO23575@dastard>
References: <CAH2r5murzVmOVnRchq=U-jx74U96g7N6Y42CW0iX4HKpWnbmxw@mail.gmail.com>
 <20141114000216.GN28565@dastard>
 <CAH2r5mvi2LijxWia2sCf+em7rfPtBn_fg6WKU=aftVUTuzXMgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	fstests@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:4107 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752740AbaKQUip (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Nov 2014 15:38:45 -0500
Content-Disposition: inline
In-Reply-To: <CAH2r5mvi2LijxWia2sCf+em7rfPtBn_fg6WKU=aftVUTuzXMgw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2014 at 05:20:34PM -0800, Steve French wrote:
> On Thu, Nov 13, 2014 at 6:02 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Nov 13, 2014 at 05:38:53PM -0600, Steve French wrote:
> >> To get xfstests to build on Ubuntu 14.10 and run (after adding various
> >> packages I could get all but 11 of the tests to build and run) I had
> >> to install the following packages:
> >>
> >> sudo apt-get install xfslibs-dev uuid-dev libtool e2fsprogs automake
> >> libuuid1 libuuidm-ocaml-dev attr libattr1-dev libacl1-dev libaio-dev
> >> xfsprogs libgdbm-dev gawk fio dbench
> >
> > Documentation patch for the README file?
> >
> > Cheers,
> >
> > Dave.
> 
> Patch attached

There are two copies of it in this email - one pasted in the middle
of the rest of the quoted email text and so is whitespace damaged,
the other as a base64 encoded attachment so can't be quoted and
replied to easily. In future, can you send patches as separate
emails according to:

https://www.kernel.org/doc/Documentation/email-clients.txt

> [PATCH] common: update README to list build dependencies
> 
> Add sample list of packages (dependencies) required to build XFSTESTS
> and add a step to the instructions to mention creating the test
> user needed for some of the ACL tests.
> 
> Signed-off-by: Steve French <smfrench@gmail.com>
> ---
>  README            | 6 ++++++
> 
> 
> diff --git a/README b/README
> index 8a362bd..8db7efe 100644
> --- a/README
> +++ b/README
> @@ -4,8 +4,14 @@ _______________________
> 
>  Building Linux:
>      - cd into the xfstests directory
> +    - install prerequisite packages
> +      For example, for Ubuntu:
> +        "sudo apt-get install xfslibs-dev uuid-dev libtool e2fsprogs
> +         automake gcc libuuid1 libuuidm-ocaml-dev attr libattr1-dev
                                  ^^^^^^^^^^^^^^^^^^

What in xfstests is dependent on ocaml?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
