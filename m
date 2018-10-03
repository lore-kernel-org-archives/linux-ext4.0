Return-Path: <SRS0=mHRP=MP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50046 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbeJCJay (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 3 Oct 2018 05:30:54 -0400
Date: Tue, 2 Oct 2018 22:44:30 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/3] docs: fix ext4 documentation table formatting
 problems
Message-ID: <20181003024430.GD18521@thunk.org>
References: <153798873160.29896.3647029167086263735.stgit@magnolia>
 <153798874404.29896.13874497175009142479.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153798874404.29896.13874497175009142479.stgit@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 26, 2018 at 12:05:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> It turns out that the latex table formatters lay out table columns with
> the exact proportional widths given in the table metadata, even if text
> overflows outside the box.  This was not caught during the initial
> import because the HTML renderers are smart enough to fudge the table.
> 
> Fix the table column width formatting problems in the data structures
> and algorithms documentation so that we don't have squashed columns.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
