From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 02/12 v2] Revert "ext4: fix fsx truncate failure"
Date: Mon, 16 Jul 2012 09:35:02 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1207160917360.5313@dhcp-1-248.brq.redhat.com>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com> <1342185555-21146-2-git-send-email-lczerner@redhat.com> <20120713174209.GC17109@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, achender@linux.vnet.ibm.com,
	Hugh Dickins <hughd@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab2GPHfM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2012 03:35:12 -0400
In-Reply-To: <20120713174209.GC17109@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 13 Jul 2012, Theodore Ts'o wrote:

> Date: Fri, 13 Jul 2012 13:42:09 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
>     achender@linux.vnet.ibm.com
> Subject: Re: [PATCH 02/12 v2] Revert "ext4: fix fsx truncate failure"
> 
> Hi Lukas,
> 
> This patch set has changes to the VFS, XFS, and ext4, and there are
> cross dependencies between them.  Is there any way you can disentagle
> the dependencies between the patches so we don't need to worry about
> how these get pulled in during the merge window?
> 
> I suppose could try to get the XFS folks to sign off with my carrying
> this patch in the ext4 tree, since the bulk of the changes are
> ext4-related, but it is a bit of a complication.
> 
> 	      	     	      	 - Ted

Hi Ted,

there is no VFS change, MM is probably what you've had in mind ? So
the only reason why there are xfs, mm and tmpfs changes is that I am
changing truncate_partial_page() and a small side effect is changed
calling conventions.

We can push patches 3, 4, 5 and 6 through the mm tree. But we'll
have to make sure that it will land before ext4 changes since I am
using the new truncate_partial_page() behaviour in ext4. Will that
be possible ?

Hugh ?

-Lukas
