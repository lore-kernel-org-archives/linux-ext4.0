Return-Path: <SRS0=d5+7=MT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:34608 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbeJGVwn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 7 Oct 2018 17:52:43 -0400
Date: Sun, 7 Oct 2018 08:45:14 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] docs: promote the ext4 data structures book to top
 level
Message-ID: <20181007084514.57c945d0@lwn.net>
In-Reply-To: <20181005234952.GC2548@thunk.org>
References: <153870117116.30837.1220267868954289184.stgit@magnolia>
        <153870118415.30837.3990077919915459798.stgit@magnolia>
        <20181005234952.GC2548@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 5 Oct 2018 19:49:52 -0400
"Theodore Y. Ts'o" <tytso@mit.edu> wrote:

> On Thu, Oct 04, 2018 at 05:59:44PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move the ext4 data structures book to Documentation/filesystems/ext4/
> > since the administrative information moved elsewhere.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>  
> 
> Thanks, applied and pushed out to the ext4.git tree.
> 
> Randy, Jon: the original patch didn't make it past vger.kernel.org
> because it was too large (it was moving a lot of files around).  It
> looked fine to me, but if you want to take a look it should be on the
> dev branch of the ext4.git tree.

FWIW, from a quick look it seems fine to me.

   Acked-by: Jonathan Corbet <corbet@lwn.net>

(though I expect it's too late to add that).

jon
