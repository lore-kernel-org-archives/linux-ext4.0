From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2 3/4] ext4: Move some static functions around
Date: Thu, 4 Jun 2009 09:47:10 -0400
Message-ID: <20090604134710.GI21314@mit.edu>
References: <1244095805-17015-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1244095805-17015-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1244095805-17015-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42727 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbZFDNrP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jun 2009 09:47:15 -0400
Content-Disposition: inline
In-Reply-To: <1244095805-17015-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 04, 2009 at 11:40:04AM +0530, Aneesh Kumar K.V wrote:
> Move some static functions around so that we can
> avoid some forward declaration. Also fix some compile
> warnings

I've added this with the changelog commit:

    ext4: Move __ext4_journalled_writepage() to avoid forward declaration
    
    In addition, fix two unused variable warnings.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

I also dropped the bh initialization in fs/ext4/namei.c:empty_dir(),
since it's clearly unnecessary and gcc 4.3.3 doesn't emit a warning.

      	   	   	       	       	     - Ted
