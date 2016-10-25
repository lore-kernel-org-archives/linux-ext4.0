From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: resizing file system fails when file system block size is
 smaller than page size
Date: Tue, 25 Oct 2016 13:19:36 -0400
Message-ID: <20161025171936.uk2l7arhwmbrlib5@thunk.org>
References: <CAA1ppbijDUUH2AN40qkoC-w88sz6BBSz89rtvXPiT089pHYgqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jerry Lee <jerrylee@qnap.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41942 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759445AbcJYRTj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Oct 2016 13:19:39 -0400
Content-Disposition: inline
In-Reply-To: <CAA1ppbijDUUH2AN40qkoC-w88sz6BBSz89rtvXPiT089pHYgqQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 09, 2016 at 07:36:06PM +0800, Jerry Lee wrote:
> 
> I have a file system with 4K block size on a 32K page size platform, and
> something strange happened when expanding the file system from size 17TB to
> 20TB.  It seems that the new file system size is not calculated correctly.
> 
> $ resize2fs /dev/mapper/dev
> resize2fs 1.43.3 (04-Sep-2016)
> Filesystem at /dev/mapper/dev is mounted on /share/DATA; on-line
> resizing required
> resize2fs: On-line shrinking not supported
> 
> After digging into the issue, I find that the following operation makes the
> high 32bit of the new_size variable be wiped out and results in a smaller
> size compared to the currently used block counts.

Thanks for the report; I've applied your suggested fix.

       	       	       	    	    - Ted
