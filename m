From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] misc: fix all the compiler warnings
Date: Fri, 3 Mar 2017 10:04:00 -0500
Message-ID: <20170303150400.fleqrkrhxritrt7m@thunk.org>
References: <148843032650.21733.13980225191301375698.stgit@birch.djwong.org>
 <148843033271.21733.1120873236425357085.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59320 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751588AbdCCPEE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 3 Mar 2017 10:04:04 -0500
Content-Disposition: inline
In-Reply-To: <148843033271.21733.1120873236425357085.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 01, 2017 at 08:52:12PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix the various compiler warnings that have crept in, and only define
> __bitwise if the system headers haven't already done so.  Linux 4.10
> changes the __bitwise definition so that our redefinition here is
> just different enough that gcc complains.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks!!

						- Ted
