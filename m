From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/6] xfstest-bld: use parallel gzip if possible
Date: Sat, 20 Aug 2016 18:52:08 -0400
Message-ID: <20160820225208.GC855@thunk.org>
References: <1471553651-9547-1-git-send-email-dmonakhov@openvz.org>
 <1471553651-9547-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48746 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751222AbcHTWwM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 20 Aug 2016 18:52:12 -0400
Content-Disposition: inline
In-Reply-To: <1471553651-9547-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 19, 2016 at 12:54:09AM +0400, Dmitry Monakhov wrote:
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  gen-tarball                                  | 4 +++-
>  kvm-xfstests/gce-xfstests                    | 5 +++--
>  kvm-xfstests/kvm-xfstests                    | 3 ++-
>  kvm-xfstests/test-appliance/gce-create-image | 3 ++-
>  4 files changed, 10 insertions(+), 5 deletions(-)

I've applied just the gen-tarball portion of the patch, because that's
where using the parallelized gzip makes a difference.  For small
files, pigz can actually take a tiny bit _more_ time.

       	    		      	     	 - Ted
